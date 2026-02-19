#!/usr/bin/env bash

TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [ -L $TARGET ]; then
  rm $TARGET
fi

ln -sf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-kickstart-2" $TARGET
