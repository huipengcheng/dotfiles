function dotfiles_sync
    command ~/scripts/dotfiles.sh
end
#
#echo "Stowing configurations for $HOME..."
#cd "$DOTFILES_DIR/home" || exit
#stow -t ~ .
#
#echo "Stowing configurations for /etc..."
#cd "$DOTFILES_DIR/etc" || exit
#
#echo "All configurations stowed successfully!"
