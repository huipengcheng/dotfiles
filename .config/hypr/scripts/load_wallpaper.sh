#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  exit 1
fi

WALLPAPER="$1"
if [ ! -f $WALLPAPER ]; then
  exit 1
fi

if ! pgrep hyprpaper >/dev/null; then
  hyprctl keyword exec hyprpaper &
fi

hyprctl hyprpaper reload ,"$WALLPAPER"
hyprctl hyprpaper unload unused
