#!/usr/bin/env bash
set -euo pipefail

TARGET="/etc/keyd"
MANAGED_SOURCE="${DOTFILES_DIR:-}/keyd/root/etc/keyd"

if [[ ! -e "$TARGET" && ! -L "$TARGET" ]]; then
  echo "[keyd] $TARGET does not exist; stow will create the managed symlink."
  exit 0
fi

if [[ -L "$TARGET" && -n "${DOTFILES_DIR:-}" && -e "$MANAGED_SOURCE" ]]; then
  if [[ "$(readlink -f "$TARGET")" == "$(readlink -f "$MANAGED_SOURCE")" ]]; then
    exit 0
  fi
fi

if [[ "${DOTFILES_DRY_RUN:-false}" == "true" ]]; then
  echo "[keyd] Existing $TARGET may conflict with stow."
  exit 0
fi

echo "[keyd] Existing $TARGET detected; installation will proceed without backup. Handle conflicts manually if stow reports one."
