#!/usr/bin/env bash

set -x

if [ $# -lt 1 ]; then
  exit 1
fi

WALLPAPER="$1"
if [[ ! -e $WALLPAPER ]]; then
  exit 1
fi

if ! pgrep hyprpaper >/dev/null; then
  hyprctl keyword exec hyprpaper
fi

# hyprctl hyprpaper reload ,"$WALLPAPER"
# hyprctl hyprpaper unload unused
hyprctl hyprpaper wallpaper ", $WALLPAPER, "
