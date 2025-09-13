#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $SCRIPT_DIR/.config
if [ -n "$WAYLAND_DISPLAY" ]; then
  ln -sf chromium-flags.conf.wayland chromium-flags.conf
fi
