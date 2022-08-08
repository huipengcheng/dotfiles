# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -U PATH # Prevents duplicates of PATH variables.

# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/url-quote-magic
autoload -Uz url-quote-magic

##############
# Navigation #
##############
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

###########
# History #
###########
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

###############
# Completions #
###############
fpath=(${ZSH}/completions $fpath)
autoload -U compinit; compinit -d "${ZSH_CACHE_DIR}/.zcompdump"

#############
# functions #
#############

cdls() {
        local dir="$1"
        local dir="${dir:=$HOME}"
        if [[ -d "$dir" ]]; then
                cd "$dir" >/dev/null; ls -lAh --color=auto
        else
                echo "bash: cdls: $dir: Directory not found"
        fi
}

function proxy_on() {
    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy=$http_proxy
    export all_proxy=socks5://127.0.0.1:7890
    echo "Proxy environment variable set."
}
function proxy_off(){
    unset http_proxy http_proxy all_proxy
    echo -e "Proxy environment variable removed."
}
proxy_on > /dev/null

up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

#########
# alias #
#########

# Changing "ls" to "exa"
alias ls='exa --color=always --group-directories-first' # my preferred listing
alias la='exa -al --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# git
alias ga='git add'
alias gaa='git add --all'
alias gcmsg='git commit -m'
alias gcv='git commit -av'
alias gst='git status'
alias gp='git push'


# pacman and yay
alias pacs='sudo pacman -S'
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias paccc='sudo pacman -Scc'
alias yays='yay -S'
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias yaycc='yay -Scc'
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # remove orphaned packages

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# grep color
alias grep="grep --color='auto'"

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# fast navigation
alias ".."="cd .."
alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

# Play audio files in current dir by type
alias playwav='deadbeef *.wav'
alias playogg='deadbeef *.ogg'
alias playmp3='deadbeef *.mp3'

# Play video files in current dir by type
alias playavi='vlc *.avi'
alias playmov='vlc *.mov'
alias playmp4='vlc *.mp4'

alias zshenv="vim ~/.zshenv"
alias zshrc="vim ~/.zshrc"
alias config="cd ~/dotfiles"

alias vim='nvim'
alias obsidian='AppImageLauncher ~/Applications/Obsidian* &'

# pass
alias passpush='(cd ~/.password-store && git push)'

# rclone
alias mountzotfile='rclone mount TeraCloud-WebDav:/Reading ~/own/zotfile'

# Alias for stow
alias stowrefresh='(cd ~/dotfiles && stow .)'

alias reload='exec zsh'
alias src='exec zsh'

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

###########
# plugins #
###########
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

    #OMZP::git 
zinit wait"1" lucid light-mode for\
    OMZP::extract OMZP::gitignore  OMZP::cp OMZP::safe-paste \
    OMZP::colored-man-pages OMZP::copyfile OMZP::copypath OMZP::copybuffer \
    OMZP::colorize OMZP::history OMZP::command-not-found \

zinit wait"3" lucid light-mode for\
    dashixiong91/zsh-vscode paulirish/git-open \
    romkatv/zsh-prompt-benchmark \
    OMZP::web-search OMZP::sudo OMZP::dirhistory \

zinit wait lucid light-mode for\
    atload'export YSU_MESSAGE_POSITION="after"' \
        MichaelAquilina/zsh-you-should-use \
    atload"export _Z_DATA='$ZSH_CACHE_DIR/.z'" \
        rupa/z \
        jimeh/zsh-peco-history \
        urbainvaes/fzf-marks \
        zsh-users/zsh-completions
    # atload"export DOTBARE_DIR='$HOME/.dotfiles' ; _dotbare_completion_cmd" \
    #     kazhala/dotbare \

#zinit ice as"program" \
#    atload'export PF_INFO="ascii title host os kernel uptime pkgs memory shell editor wm de palette";
#           export PF_ASCII="Linux"; export PF_COL3=5; export PF_COL1=6; export PF_COL2=8;' # pfetch
#zinit snippet 'https://github.com/dylanaraps/pfetch/blob/master/pfetch'

# vimode
zinit ice depth"1" \
    atload'ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM ;
           ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK ;
           ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK ;
           ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLOCK ;
           ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLOCK '
zinit load jeffreytse/zsh-vi-mode

# atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \ 
# should use zicompinit, but it will create .zdumpfile 
# in the home directory and can not be specified
zinit wait lucid light-mode for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"_zsh_autosuggest_start" \
  bindmap'!"^P" -> history-substring-search-up; !"^N" -> history-substring-search-down' \
    zsh-users/zsh-autosuggestions \
  atload"bindkey '^P' history-substring-search-up ; bindkey '^N' history-substring-search-down" \
    zsh-users/zsh-history-substring-search \
  atload"zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup;
         zstyle ':completion:*:git-checkout:*' sort false; 
         zstyle ':completion:*:descriptions' format '[%d]';
         zstyle ':fzf-tab:*' show-group breif;
         zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS};
         zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath';" \
    Aloxaf/fzf-tab

zinit ice depth"1" \
    atload'!source ~/.p10k.zsh'
zinit light romkatv/powerlevel10k

# forgit, not be uesd for now
# zinit ice wait lucid
# zinit load 'wfxr/forgit'
#
#  Load starship theme
#  zinit ice as"command" from"gh-r" \
#            atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#            atpull"%atclone" src"init.zsh"
#  zinit light starship/starship
# eval "$(starship init bash)"

# with installing cowsay and fortune using brew
# zinit load babasbot/auto-fortune-cowsay-zsh
# hacker-quotes fzf per-directory-history

colorscript random
