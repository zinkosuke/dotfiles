##################################################
# Colors.
##################################################
autoload -Uz colors
colors

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
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt interactive_comments
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob

##################################################
# Environ.
##################################################
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100
export SAVEHIST=5000
export EDITORP=vim
export PROMPT="$fg[red]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%} > "

##################################################
# Alias.
##################################################
case "$(uname)" in
    "Darwin")
        alias ll='ls -laFG'
        ;;
    *)
        alias ll='ls -laF --color=auto'
        ;;
esac
chpwd() { ll }

alias d='docker'
alias d-c='docker-compose'
alias g='git'
alias gp='cd $(ghq root)/$(ghq list | peco)'
alias v='vim -p'
alias vd='vim -d'
alias vg='vagrant'

##################################################
# Functions.
##################################################
function rl() {
    echo "Reload shell ${SHELL}"
    exec ${SHELL} -l
}

##################################################
# Alias on docker.
##################################################
alias jupyter='docker run --rm -it -v $(pwd):/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook start-notebook.sh --NotebookApp.token=""'
alias python='docker run --rm -it -v $(pwd):/work -w /work python:3.7-alpine'
