# Completion
autoload -Uz compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Ignore case.
zstyle ':completion:*:default' menu select=1  # Enable arrow keys.
zstyle ':completion:*' ignore-parents parent pwd ..  # Ignore current dir.
zstyle ':completion:*:sudo:*' command-path $(echo ${PATH} | tr ':' ' ')  # sudo.
zmodload zsh/complist

# Plugins
. /usr/local/opt/zplug/init.zsh

zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug "peco/peco", as:command, from:gh-r

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose

# History
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

setopt hist_ignore_all_dups  # Ignore duplicates.
setopt hist_ignore_space  # Ignore if command starts with space.
setopt hist_no_store  # Ignore `history` command.
setopt hist_reduce_blanks  # Reduce white space.
setopt hist_verify  # After selecting a history, wait before execution.
setopt inc_append_history  # Add history incrementally.
setopt share_history  # Share history on multiple terminal.

# Incremental search
function peco-inc-history() {
    BUFFER=$(history -n 1 | tail -r | awk '!a[$0]++' | peco)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-inc-history
bindkey '^R' peco-inc-history

# Delimiters
autoload -Uz select-word-style; select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
setopt extended_glob  # Enable extended notation e.g. ls test/^*.txt
setopt interactive_comments  # Comment in command line.

# Key binds (vim)
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Move dir
export DIRSTACKSIZE=100

setopt auto_cd  # Don't have to type 'cd'.
setopt auto_pushd  # Stack up dir history.
setopt pushd_ignore_dups  # Ignore duplicates.

# Editor
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less -N'

# Reload
function rl() {
    echo "Reload shell ${SHELL}"
    exec ${SHELL} -l
}

# Alias.
alias all='export AWS_PROFILE=$(grep "^\[" ~/.aws/credentials | tr -d "[]"| peco)'
alias sll='ssh $(grep "Host " ~/.ssh/config | grep -Fv "*" | cut -d" " -f 2 | peco)'
alias gll='cd $(ghq root)/$(ghq list | peco)'
alias bll='git checkout $(git branch --format="%(refname:short)" | peco)'

alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdd='git difftool'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gg='git grep'
alias gl="git log --graph --all --pretty=format:'%C(yellow)%h %C(cyan)%cd %C(reset)%s %C(red)%d %C(bold blue)<%an>%C(reset)' --abbrev-commit --date=format:'%Y-%m-%d %H:%M:%S'"
alias gla='git log --graph --all --abbrev-commit'
alias gm='git commit -m'
alias gpl='git pull'
alias gps='git push'
alias gr='git reset'
alias gs='git status -bsu'
alias gst='git stash'
alias d='docker'
alias db='docker build --force-rm=true --rm=true --no-cache=true'
alias dc='docker container ls -a' # Overwrite command if exists.
alias de='docker exec -it'
alias di='docker image ls'
alias dn='docker network ls'
alias dr='docker run -it --rm'
alias dv='docker volume ls'
alias d-c='docker-compose'
alias vg='vagrant'
alias vgg='vagrant global-status'
alias ll='ls -lahFG'  # For mac.
alias v='vim -p'
alias vd='vim -d'
alias x='xargs'

# Prompt with git
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "🔔"
zstyle ':vcs_info:git:*' unstagedstr "🍣"
zstyle ':vcs_info:*' formats "%F{247}%S%f [%F{009}%r%f|%F{129}%b%f%c%u]"
zstyle ':vcs_info:*' actionformats '%F{247}%S%f [%r/%b|%a]'

# Hooks
chpwd() {
    ll
}

precmd() {
    vcs_info
    PR_AWS=''
    D=''
    if [ "${vcs_info_msg_0_}" = "" ]; then
        D='%~'
    fi
    if [ "${AWS_PROFILE}" != "" ]; then
        PR_AWS="[%F{129}${AWS_PROFILE}%f🌩 ]"
    fi

    PROMPT='%n%F{020}@%f%m %F{247}${D}%f ${vcs_info_msg_0_} ${PR_AWS}
%F{009}>>>%f '
}

# Show colors
# for c in {000..255}; do
#     echo -n "\e[38;5;${c}m $c"
#     [ $(($c%16)) -eq 15 ] && echo
# done; echo
