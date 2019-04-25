##################################################
# Colors.
##################################################
# TODO If enabled, display is broken.
#autoload -Uz colors
#colors

##################################################
# Delimiters.
##################################################
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

##################################################
# Completion.
##################################################
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' ignore-parents parent pwd ..
zmodload zsh/complist

##################################################
# Key binds
##################################################
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey "^R" history-incremental-search-backward

##################################################
# Options.
##################################################
# `cd`.
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
# Comment in command line.
setopt interactive_comments
# `history`.
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
# Enable extended notation
setopt extended_glob

##################################################
# Environ.
##################################################
# History.
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100
export SAVEHIST=100
# `cd`.
export DIRSTACKSIZE=50
# Editor.
export EDITORP='vim'
export VISUAL='vim'
export PAGER='less -N'
# Prompt.
export PROMPT="$fg[red]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} > "

##################################################
# Alias.
##################################################
# Git.
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias gcl='git clone'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch'
alias gg='git grep'
alias gl='git log --graph --all --abbrev-commit'
alias glo='git log --graph --all --abbrev-commit --oneline'
alias gm='git commit -m'
alias gpl='git pull'
alias gps='git push'
alias gr='git reset'
alias gs='git status -bsu'
alias gst='git stash'
alias grr='cd $(ghq root)/$(ghq list | peco)'
alias gbb='git checkout $(git branch --format="%(refname:short)" | peco)'

# Docker.
alias d='docker'
alias db='docker build --force-rm=true --rm=true --no-cache=true'
alias dc='docker container ls -a' # Overwrite command if exists.
alias di='docker image ls'
alias dn='docker network ls'
alias dr='docker run -it --rm'
alias d-c='docker-compose'

alias jupyter='docker run --rm -it -v $(pwd):/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook start-notebook.sh --NotebookApp.token=""'
alias python='docker run --rm -it -v $(pwd):/work -w /work python:3.7-alpine'

# Others.
case "$(uname)" in
    "Darwin")
        alias ll='ls -lAFG'
        ;;
    *)
        alias ll='ls -lAF --color=auto'
        ;;
esac
alias v='vim -p'
alias vd='vim -d'
alias vg='vagrant'
alias x='xargs'

##################################################
# Functions.
##################################################
chpwd() { ll }

function rl() {
    echo "Reload shell ${SHELL}"
    exec ${SHELL} -l
}
