#!/bin/bash

# support GTK only

GTK_LIGHT_THEME="Arc-Dark"
GTK_LIGHT_COLOR_SCHEME="prefer-light"

GTK_DARK_THEME="Arc-Dark"
GTK_DARK_COLOR_SCHEME="prefer-dark"


# QT_CONF="$HOME/.config/qt5ct/qt5ct.conf"
# QT_LIGHT="$HOME/.config/qt5ct/colors/light.conf"
# QT_DARK="$HOME/.config/qt5ct/colors/dark.conf"

THEME="$1"
case "$THEME" in
  light)
    echo "Swith to light..."
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_LIGHT_THEME"
    gsettings set org.gnome.desktop.interface color-scheme "$GTK_LIGHT_COLOR_SCHEME"
    gsettings set org.gnome.desktop.interface icon-theme "Adwaita"

    # sed -i "s|^color_scheme_path=.*|color_scheme_path=$QT_LIGHT|" "$QT_CONF"
    ;;
  dark)
    echo "Swith to dark..."
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_DARK_THEME"
    gsettings set org.gnome.desktop.interface color-scheme "$GTK_DARK_COLOR_SCHEME"
    gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
    ;;
  *)
    echo "Usage: $0 {light|dark}"
    exit 1
    ;;
esac
