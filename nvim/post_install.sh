#!/usr/bin/env bash

TARGET="$XDG_CONFIG_HOME/nvim"

if [ -L $TARGET ]; then
  rm $TARGET
fi

ln -sf $XDG_CONFIG_HOME/nvim-kickstart $TARGET
