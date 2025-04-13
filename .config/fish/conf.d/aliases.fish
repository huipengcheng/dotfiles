# Colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'


alias vim='nvim'

alias ll 'eza -lAg --git --icons --group-directories-first'
alias llm 'eza -lAg --git --icons --group-directories-first --sort modified'
alias tree 'eza -Ta --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'
alias ltd 'eza -TaD --icons --ignore-glob="node_modules|.git|.vscode|.DS_Store"'

alias src='exec fish'

alias proj='cd ~/dev/projects'

alias pacman='sudo pacman'
alias pacmanclean='pacman -Qdtq | pacman -Rns -'

alias vim-lazy='NVIM_APPNAME="nvim-lazy" nvim'

alias gst='git status'
alias gcmsg='git commit -m'
alias ga='git add'
alias gaa='git add --all'
alias gp='git push'
