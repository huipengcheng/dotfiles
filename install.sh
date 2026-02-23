#!/usr/bin/env bash
set -eo pipefail

DOTFILES_DIR="$HOME/dotfiles"
DEFAULT_PACKAGES=(
  "bash" "bat" "bin" "chromium" "electron" "fastfetch"
  "fcitx5" "fish" "git" "gtk" "hypr" "keyd" "kitty"
  "nvim" "paru" "qtile" "rime" "script" "starship"
  "stow" "waybar" "wofi" "x11" "zathura"
  "agents" "qoder"
)
ALLOWED_SYSTEM_PATHS=(
  "/etc/keyd"
)

DRYRUN=false
VERBOSE=false
PACKAGES=()

# --- Argument Parsing ---
for arg in "$@"; do
  case "$arg" in
  --dry-run) DRYRUN=true ;;
  --verbose | -v) VERBOSE=true ;;
  -*) echo -e "\033[33m[WARN]\033[0m Unknown option: $arg" ;;
  *) PACKAGES+=("$arg") ;;
  esac
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
  PACKAGES=("${DEFAULT_PACKAGES[@]}")
fi

# --- Logging Helpers ---
log_debug() { if [ "$VERBOSE" = "true" ]; then echo -e "\033[36m[DEBUG]\033[0m $*"; fi; }
log_info() { echo -e "\033[32m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $*"; }

trap 'log_error "Script error at line $LINENO"; exit 1' ERR

# --- Path Validation Helpers ---
is_path_in_allowed_tree() {
  local target="$1"
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

  if [ -z "$(ls -A "$root_src_dir" 2>/dev/null)" ]; then
    return 0
  fi

  while IFS= read -r -d '' file; do
    local rel_path="${file#$root_src_dir/}"
    local target_path="/$rel_path"

    local current_path=""
    IFS='/' read -ra PARTS <<<"$target_path"

    for part in "${PARTS[@]}"; do
      if [ -z "$part" ]; then continue; fi

      current_path="${current_path}/${part}"

      if ! is_path_in_allowed_tree "$current_path"; then

        local already_flagged=false
        for v in "${flagged_targets[@]}"; do
          if [[ "$v" == "$current_path" ]]; then
            already_flagged=true
            break
          fi
        done

        if ! $already_flagged; then
          flagged_targets+=("$current_path")
          has_errors=true
          # Output the exact requested format with yellow color for the path
          log_error "Security Block: Deployment to '\033[33m${pkg_name}${current_path}\033[0m' is not in ALLOWED_SYSTEM_PATHS."
        fi

        break
      fi
    done
  done < <(find "$root_src_dir" -type f -print0)

  if $has_errors; then
    return 1
  fi

  return 0
}

# --- Hook Executor ---
run_hook() {
  local pkg_name=$1
  local hook_dir=$2
  local hook_name=$3
  local hook_file="$hook_dir/$hook_name.sh"

  if [ -f "$hook_file" ]; then
    if $DRYRUN; then
      log_info "--- DRY RUN: would execute $hook_name for $pkg_name ---"
    else
      [ ! -x "$hook_file" ] && chmod +x "$hook_file"
      log_debug "--- Running $hook_name for $pkg_name ---"
      if ! "$hook_file"; then
        log_error "Execution of $hook_name failed for $pkg_name"
        exit 2
      fi
    fi
  fi
}

# --- Stow Executors ---
stow_user_configs() {
  local pkg=$1
  # Ignore root directory, hooks, and markdown files
  local stow_args=("-t" "$HOME" "--ignore=^root" "--ignore=pre_install.sh" "--ignore=post_install.sh" "--ignore=.*\.md")

  $DRYRUN && stow_args+=("-nv")
  stow_args+=("$pkg")

  log_debug "Running: stow ${stow_args[*]}"
  if ! stow "${stow_args[@]}"; then
    log_error "User stow failed for package $pkg"
    exit 3
  fi
}

stow_system_configs() {
  local pkg=$1
  local pkg_dir="$DOTFILES_DIR/$pkg"
  local root_dir="$pkg_dir/root"

  if [ -d "$root_dir" ]; then
    log_info "Detected system-level configs for $pkg. Validating paths..."

    if ! validate_system_paths "$root_dir" "$pkg"; then
      log_error "Path validation failed for $pkg. Aborting to protect system integrity."
      exit 4
    fi

    log_info "Path validation passed for $pkg. Sudo access required."

    local stow_args=("-d" "$pkg_dir" "-t" "/")
    $DRYRUN && stow_args+=("-nv")
    stow_args+=("root")

    log_debug "Running: sudo stow ${stow_args[*]}"
    if ! sudo stow "${stow_args[@]}"; then
      log_error "System stow failed for package $pkg"
      exit 5
    fi
  fi
}

# --- Main Execution ---
log_info "Starting dotfiles installation..."

# Step 1: Run Backup
if [ -x "$DOTFILES_DIR/backup.sh" ]; then
  log_info "Running backup script..."
  if $DRYRUN; then
    log_debug "--- DRY RUN: would execute backup.sh ---"
  else
    "$DOTFILES_DIR/backup.sh"
  fi
else
  log_warn "backup.sh not found or not executable. Skipping backup."
fi

# Step 2: Global Pre-Install
log_debug "=== Running global pre_install ==="
run_hook "main" "$DOTFILES_DIR" "pre_install"

# Step 3: Process Packages
cd "$DOTFILES_DIR" || exit 1

for pkg in "${PACKAGES[@]}"; do
  pkg_dir="$DOTFILES_DIR/$pkg"

  if [ -d "$pkg_dir" ]; then
    log_info "Deploying: $pkg"

    run_hook "$pkg" "$pkg_dir" "pre_install"
    stow_user_configs "$pkg"
    stow_system_configs "$pkg"
    run_hook "$pkg" "$pkg_dir" "post_install"

    log_debug "=== Finished $pkg ==="
  else
    log_warn "Package directory $pkg_dir does not exist, skipping."
  fi
done

# Step 4: Global Post-Install
log_debug "=== Running global post_install ==="
run_hook "main" "$DOTFILES_DIR" "post_install"

log_info "Dotfiles deployment complete!"
