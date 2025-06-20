if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -e /opt/homebrew
    /opt/homebrew/bin/brew shellenv | source
end
if test -e ~/.zshenv
    source ~/.zshenv
end

starship init fish | source

function fish_greeting
end

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

if not set -q fish_vim_mode; or test "$fish_vim_mode" = "enable"
    # Emulates vim's cursor shape behavior
    # Set the normal and visual mode cursors to a block
    set fish_cursor_default block
    # Set the insert mode cursor to a line
    set fish_cursor_insert line
    # Set the replace mode cursors to an underscore
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    # Set the external cursor to a line. The external cursor appears when a command is started.
    # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
    set fish_cursor_external line
    # The following variable can be used to configure cursor shape in
    # visual mode, but due to fish_cursor_default, is redundant here
    set fish_cursor_visual block
end


# kitty 在 DoomOne 下，suggestion 的颜色太浅了，调深一点
# set -g fish_color_autosuggestion "888"
