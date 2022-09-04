#!/usr/bin/env zsh

typeset -U PATH # Prevents duplicates of PATH variables.

export TERM='xterm-256color'
export DOTFILES="$HOME/.dotfiles"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# editor
export EDITOR="nvim"
export VISUAL="nvim"

# zsh
export ZSH="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export HISTFILE="$ZSH_CACHE_DIR/.zhistory"        # History filepath
export HISTSIZE=50000                         # Maximum events for internal history
export SAVEHIST=10000                         # Maximum events in history file

# PATH
export PATH="$HOME/.local/bin:$PATH"
