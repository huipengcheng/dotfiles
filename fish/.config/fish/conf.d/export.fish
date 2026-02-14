export EDITOR=nvim

# export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export MANPAGER="nvim +Man!"

abbr -a --position anywhere -- --help '--help | bat -plhelp'
abbr -a --position anywhere -- -h '-h | bat -plhelp'

#export MANPAGER="less -R --use-color -Dd+r -Du+b"
#export MANROFFOPT="-P -c"
