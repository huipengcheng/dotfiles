#!/bin/bash

DOTFILES_DIR=~/dotfiles

echo "Stowing configurations for $HOME..."
cd "$DOTFILES_DIR/home" || exit
stow -t ~ .

echo "Stowing configurations for /etc..."
cd "$DOTFILES_DIR/etc" || exit
sudo stow -t /etc .

echo "All configurations stowed successfully!"
