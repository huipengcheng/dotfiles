#!/usr/bin/env bash
set -e
DOTFILES_DIR="$HOME/dotfiles"
DEFAULT_PACKAGES=(
  "bat"
  "chromium"
  "electron"
  "fastfetch"
  "fcitx5"
  "fish"
  "git"
  "gtk"
  "hypr"
  "keyd"
  "kitty"
  "nvim"
  "paru"
  "qtile"
  "script"
  "starship"
  "stow"
  "waybar"
  "wofi"
)

DRYRUN=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run)
    DRYRUN=true
    shift
    ;;
  --verbose | -v)
    VERBOSE=true
    shift
    ;;
  *)
    PACKAGES+=("$1")
    shift
    ;;
  esac
done

if [ ${#PACKAGES[@]} -eq 0 ]; then
  PACKAGES=("${DEFAULT_PACKAGES[@]}")
fi

log_debug() { if [ "$VERBOSE" = "true" ]; then echo -e "\033[36m[DEBUG]\033[0m $*"; fi; }
log_info() { if [ "$VERBOSE" = "true" ]; then echo -e "\033[32m[INFO]\033[0m $*"; fi; }
log_warn() { if [ "$VERBOSE" = "true" ]; then echo -e "\033[33m[WARN]\033[0m $*"; fi; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $*"; }

trap 'log_error "Script error at line $LINENO"; exit 1' ERR

run_hook() {
  local pkg_name=$1
  local hook_dir=$2
  local hook_name=$3

  if [ -f "$hook_dir/$hook_name.sh" ]; then
    if $DRYRUN; then
      log_debug "--- DRY RUN: would execute $hook_name for $pkg ---"
    else
      if [ ! -x "$hook_dir/$hook_name.sh" ]; then
        chmod +x $hook_dir/$hook_name.sh
      fi
      log_debug "--- Running $hook_name for $pkg ---"
      if ! $hook_dir/$hook_name.sh; then
        log_error "Execute $hook_name failed for $pkg"
        exit 2
      fi
    fi
  fi
}

run_stow() {
  STOW_CMD="stow -t $HOME --ignore pre_install.sh --ignore post_install.sh"
  $DRYRUN && STOW_CMD+=" -nv"
  STOW_CMD+=" $pkg"
  log_debug "--- Running: $STOW_CMD ---"
  if ! eval "$STOW_CMD"; then
    log_error "Stow failed for package $pkg"
    exit 3
  fi
}

./install_backup.sh

log_debug "=== Running global pre_install ==="
run_hook "main" $DOTFILES_DIR "pre_install"

for pkg in "${PACKAGES[@]}"; do
  pkg_dir="$DOTFILES_DIR/$pkg"

  if [ -d "$pkg_dir" ]; then
    log_debug "=== Deploying $pkg ==="

    run_hook $pkg $pkg_dir "pre_install"
    run_stow
    run_hook $pkg $pkg_dir "post_install"

    log_debug "=== Finished $pkg ==="
  else
    log_debug "Package directory $pkg_dir does not exist, skipping."
  fi
done

log_debug "=== Running global post_install ==="
run_hook "main" $DOTFILES_DIR "post_install"
