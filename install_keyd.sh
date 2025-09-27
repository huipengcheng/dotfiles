#!/usr/bin/env bash
set -e

DOTFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${DOTFILE_DIR}/etc/keyd"
DEST="/etc/keyd"

if [ ! -d "$SRC" ]; then
    echo "Source directory $SRC does not exist"
    exit 1
fi

if [ -L "$DEST" ]; then
    LINK_TARGET=$(readlink "$DEST")
    if [ "$LINK_TARGET" = "$SRC" ]; then
        echo "$DEST is already a symlink to $SRC, skipping."
        exit 0
    else
        echo "$DEST is a symlink to $LINK_TARGET, replacing..."
        sudo rm "$DEST"
    fi
elif [ -e "$DEST" ]; then
    echo "$DEST exists and is not a symlink, replacing..."
    sudo rm -rf "$DEST"
fi

sudo ln -s "$SRC" "$DEST"
echo "Symlink created: $DEST -> $SRC"

