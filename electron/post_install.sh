#!/usr/bin/env bash
set -euo pipefail

is_wayland_session() {
  [[ -n "${WAYLAND_DISPLAY:-}" || "${XDG_SESSION_TYPE:-}" == "wayland" ]]
}

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET="$CONFIG_HOME/electron-flags.conf"
SOURCE="$CONFIG_HOME/electron-flags.conf.wayland"
BACKUP_PATH="${TARGET}.pre-dotfiles-$(date +%Y-%m-%d_%H-%M-%S)"

if [[ "${DOTFILES_DRY_RUN:-false}" == "true" ]]; then
  if is_wayland_session; then
    if [[ -e "$TARGET" || -L "$TARGET" ]]; then
      echo "[electron] Would move existing $TARGET to $BACKUP_PATH and link it to $SOURCE."
    else
      echo "[electron] Would link $TARGET to $SOURCE."
    fi
  elif [[ -L "$TARGET" && "$(readlink -f "$TARGET")" == "$(readlink -f "$SOURCE")" ]]; then
    echo "[electron] Would remove the managed Wayland link at $TARGET."
  else
    echo "[electron] No Wayland session detected; no electron flags change needed."
  fi
  exit 0
fi

if ! is_wayland_session; then
  if [[ -L "$TARGET" && "$(readlink -f "$TARGET")" == "$(readlink -f "$SOURCE")" ]]; then
    rm "$TARGET"
  fi
  exit 0
fi

if [[ ! -e "$SOURCE" ]]; then
  echo "[electron] Expected $SOURCE to exist after stow."
  exit 1
fi

if [[ -L "$TARGET" && "$(readlink -f "$TARGET")" == "$(readlink -f "$SOURCE")" ]]; then
  exit 0
fi

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  mv "$TARGET" "$BACKUP_PATH"
fi

ln -sfnT "$SOURCE" "$TARGET"
