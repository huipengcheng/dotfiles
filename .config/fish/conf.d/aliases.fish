alias falias='vim ~/.config/fish/conf.d/aliases.fish'
alias fexport='vim ~/.config/fish/conf.d/export.fish'

alias proj='cd ~/dev/projects'
alias notes='cd ~/own/obsidian/notes/'
alias dotfiles='cd ~/dotfiles/'


# Colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'


alias vim='nvim'
alias vl='NVIM_APPNAME=nvim-lazyvim nvim'

# alias ll 'eza -lAg --git --icons --group-directories-first'
# alias llm 'eza -lAg --git --icons --group-directories-first --sort modified'
alias ll 'eza -lAg --git --group-directories-first'
alias llm 'eza -lAg --git --group-directories-first --sort modified'
alias tree 'eza -Ta --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'
alias ltd 'eza -TaD --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'

alias src='exec fish'

alias pacman='sudo pacman'
alias pacmanclean='pacman -Qdtq | pacman -Rns -'
alias parus='paru -S'
alias paruss='paru -Ss'
alias parur='paru -Rsc'
alias paraq='paru -Q'

alias vim-lazy='NVIM_APPNAME="nvim-lazy" nvim'

alias gst='git status'
alias gcmsg='git commit -m'
alias ga='git add'
alias gaa='git add --all'
alias gp='git push'
