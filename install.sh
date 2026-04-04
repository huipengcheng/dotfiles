#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PACKAGES=(
  "Qoder" "bash" "bat" "bin" "chromium" "electron" "fastfetch"
  "fcitx5" "fish" "git" "gtk" "hypr" "keyd" "kitty"
  "nvim" "paru" "qtile" "rime" "starship" "stow"
  "waybar" "wofi" "x11" "zathura"
)
MANUAL_PACKAGES=(
  "firefox"
)
ALLOWED_SYSTEM_PATHS=(
  "/etc/keyd"
)

DRYRUN=false
VERBOSE=false
PACKAGES=()

log_debug() { if [[ "$VERBOSE" == "true" ]]; then echo -e "\033[36m[DEBUG]\033[0m $*"; fi; }
log_info() { echo -e "\033[32m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $*"; }

trap 'log_error "Script error at line $LINENO"; exit 1' ERR

contains_value() {
  local needle="$1"
  shift

  local candidate=""
  for candidate in "$@"; do
    if [[ "$candidate" == "$needle" ]]; then
      return 0
    fi
  done

  return 1
}

is_path_in_allowed_tree() {
  local target="$1"

  local allowed=""
  for allowed in "${ALLOWED_SYSTEM_PATHS[@]}"; do
    if [[ "$target" == "$allowed" ]]; then return 0; fi
    if [[ "$target" == "$allowed/"* ]]; then return 0; fi
    if [[ "$allowed" == "$target/"* ]]; then return 0; fi
  done

  return 1
}

validate_system_paths() {
  local root_src_dir="$1"
  local pkg_name="$2"
  local flagged_targets=()
  local has_errors=false

  if [[ -z "$(find "$root_src_dir" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
    return 0
  fi

  while IFS= read -r -d '' entry; do
    local rel_path="${entry#$root_src_dir/}"
    local target_path="/$rel_path"
    local current_path=""
    local parts=()
    local already_flagged=false
    local flagged=""

    IFS='/' read -r -a parts <<<"$target_path"

    for part in "${parts[@]}"; do
      if [[ -z "$part" ]]; then
        continue
      fi

      current_path="${current_path}/${part}"

      if is_path_in_allowed_tree "$current_path"; then
        continue
      fi

      already_flagged=false
      for flagged in "${flagged_targets[@]}"; do
        if [[ "$flagged" == "$current_path" ]]; then
          already_flagged=true
          break
        fi
      done

      if [[ "$already_flagged" == "false" ]]; then
        flagged_targets+=("$current_path")
        has_errors=true
        log_error "Security Block: Deployment to '\033[33m${pkg_name}${current_path}\033[0m' is not in ALLOWED_SYSTEM_PATHS."
      fi

      break
    done
  done < <(find "$root_src_dir" -mindepth 1 -print0)

  if [[ "$has_errors" == "true" ]]; then
    return 1
  fi

  return 0
}

run_hook() {
  local pkg_name="$1"
  local hook_dir="$2"
  local hook_name="$3"
  local hook_file="$hook_dir/$hook_name.sh"

  if [[ ! -f "$hook_file" ]]; then
    return 0
  fi

  if [[ "$DRYRUN" == "true" ]]; then
    log_info "--- DRY RUN: previewing $hook_name for $pkg_name ---"
  else
    log_debug "--- Running $hook_name for $pkg_name ---"
  fi

  if ! DOTFILES_DRY_RUN="$DRYRUN" \
    DOTFILES_VERBOSE="$VERBOSE" \
    DOTFILES_DIR="$DOTFILES_DIR" \
    DOTFILES_PACKAGE="$pkg_name" \
    DOTFILES_HOOK_NAME="$hook_name" \
    bash "$hook_file"; then
    log_error "Execution of $hook_name failed for $pkg_name"
    exit 2
  fi
}

stow_user_configs() {
  local pkg="$1"
  local stow_args=(
    "-t" "$HOME"
    "--no-folding"
    "--ignore=^root"
    "--ignore=pre_install.sh"
    "--ignore=post_install.sh"
    "--ignore=.*\\.md"
  )

  if [[ "$DRYRUN" == "true" ]]; then
    stow_args+=("-nv")
  fi
  stow_args+=("$pkg")

  log_debug "Running: stow ${stow_args[*]}"
  if ! stow "${stow_args[@]}"; then
    log_error "User stow failed for package $pkg"
    exit 3
  fi
}

stow_system_configs() {
  local pkg="$1"
  local pkg_dir="$DOTFILES_DIR/$pkg"
  local root_dir="$pkg_dir/root"
  local stow_args=("-d" "$pkg_dir" "-t" "/")

  if [[ ! -d "$root_dir" ]]; then
    return 0
  fi

  log_info "Detected system-level configs for $pkg. Validating paths..."

  if ! validate_system_paths "$root_dir" "$pkg"; then
    log_error "Path validation failed for $pkg. Aborting to protect system integrity."
    exit 4
  fi

  if [[ "$DRYRUN" == "true" ]]; then
    stow_args+=("-nv")
    stow_args+=("root")
    log_debug "Running: stow ${stow_args[*]}"
    if ! stow "${stow_args[@]}"; then
      log_error "System stow preview failed for package $pkg"
      exit 5
    fi
    return 0
  fi

  log_info "Path validation passed for $pkg. Sudo access required."
  stow_args+=("root")

  log_debug "Running: sudo stow ${stow_args[*]}"
  if ! sudo stow "${stow_args[@]}"; then
    log_error "System stow failed for package $pkg"
    exit 5
  fi
}

for arg in "$@"; do
  case "$arg" in
  --dry-run) DRYRUN=true ;;
  --verbose | -v) VERBOSE=true ;;
  -*) log_warn "Unknown option: $arg" ;;
  *) PACKAGES+=("$arg") ;;
  esac
done

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  PACKAGES=("${DEFAULT_PACKAGES[@]}")
fi

log_info "Starting dotfiles installation from $DOTFILES_DIR..."

if [[ -x "$DOTFILES_DIR/backup.sh" ]]; then
  log_info "Running backup script..."
  DOTFILES_DRY_RUN="$DRYRUN" "$DOTFILES_DIR/backup.sh"
else
  log_warn "backup.sh not found or not executable. Skipping backup."
fi

log_debug "=== Running global pre_install ==="
run_hook "main" "$DOTFILES_DIR" "pre_install"

cd "$DOTFILES_DIR"

for pkg in "${PACKAGES[@]}"; do
  local_pkg_dir="$DOTFILES_DIR/$pkg"

  if contains_value "$pkg" "${MANUAL_PACKAGES[@]}"; then
    log_warn "Package $pkg requires manual installation because its target path is machine-specific. Skipping."
    continue
  fi

  if [[ ! -d "$local_pkg_dir" ]]; then
    log_warn "Package directory $local_pkg_dir does not exist, skipping."
    continue
  fi

  log_info "Deploying: $pkg"

  run_hook "$pkg" "$local_pkg_dir" "pre_install"
  stow_user_configs "$pkg"
  stow_system_configs "$pkg"
  run_hook "$pkg" "$local_pkg_dir" "post_install"

  log_debug "=== Finished $pkg ==="
done

log_debug "=== Running global post_install ==="
run_hook "main" "$DOTFILES_DIR" "post_install"

log_info "Dotfiles deployment complete!"
