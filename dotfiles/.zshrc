. ~/.alias
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
export DIRSTACKSIZE=100

export EDITOR='vim'
export VISUAL='vim'
export PAGER='bat'

export AWS_DEFAULT_OUTPUT=json
export AWS_DEFAULT_REGION=ap-northeast-1

linuxbrew=/home/linuxbrew/.linuxbrew/bin/brew
if [ -f ${linuxbrew} ]; then
    eval "$(${linuxbrew} shellenv)"
fi

if [ -f ${linuxbrew} ]; then
    export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
elif [ "$(uname)" = 'Darwin' ]; then
    export ZPLUG_HOME=/usr/local/opt/zplug
fi
. ${ZPLUG_HOME}/init.zsh
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting'
if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose

autoload -Uz compinit; compinit
zstyle ':completion:*' ignore-parents parent pwd ..  # Ignore current dir.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Ignore case.
zstyle ':completion:*:default' menu select=1         # Enable arrow keys.
zstyle ':completion:*:sudo:*' command-path $(echo ${PATH} | tr ':' ' ')  # sudo.
zmodload zsh/complist

autoload -Uz select-word-style; select-word-style default
zstyle ':zle:*' word-chars ' /=-;@:()[]{},.|'
zstyle ':zle:*' word-style unspecified

setopt auto_cd               # Don't have to type 'cd'.
setopt auto_pushd            # Stack up dir history.
setopt extended_glob         # Enable extended notation e.g. ls test/^*.txt
setopt hist_ignore_all_dups  # Ignore duplicates.
setopt hist_ignore_space     # Ignore if command starts with space.
setopt hist_no_store         # Ignore `history` command.
setopt hist_reduce_blanks    # Reduce white space.
setopt hist_verify           # After selecting a history, wait before execution.
setopt inc_append_history    # Add history incrementally.
setopt interactive_comments  # Comment in command line.
setopt pushd_ignore_dups     # Ignore duplicates.
setopt share_history         # Share history on multiple terminal.

function peco_search_aws_profile() {
    local r=$(grep '^\[.*\]' ~/.aws/credentials | tr -d '[]'| sort | peco)
    if [ -n "${r}" ]; then
        export AWS_PROFILE=${r}
    else
        unset AWS_PROFILE
    fi
    zle reset-prompt
}
zle -N peco_search_aws_profile

function peco_search_ghq_look() {
    local r=$(ghq list | sort | peco)
    [ -n "${r}" ] && cd $(ghq root)/${r}
    zle reset-prompt
}
zle -N peco_search_ghq_look

function peco_search_git_branch() {
    local r=$(git branch --format='%(refname:short)' | tr -d ' ' | sort | peco)
    [ -n "${r}" ] && git checkout ${r}
    zle reset-prompt
}
zle -N peco_search_git_branch

function peco_search_history() {
    BUFFER=$(history -n 1 | tail -r | awk '!a[$0]++' | peco)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco_search_history

function peco_search_find() {
    local r=$(find . -type f | sort | peco)
    [ -n "${r}" ] && vim --not-a-term ${r}
    zle reset-prompt
}
zle -N peco_search_find

function peco_search_word() {
    # TODO rgでいいか?
    local r=$(rg "${1}" ${2:-.} | peco)
    [ -n "${r}" ] && vim --not-a-term ${r}
    zle reset-prompt
}
zle -N peco_search_word

bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey '^A' peco_search_aws_profile
bindkey '^G' peco_search_ghq_look
bindkey '^B' peco_search_git_branch
bindkey '^H' peco_search_history
bindkey '^F' peco_search_find
bindkey '^W' peco_search_word

chpwd() { l }

eval "$(starship init zsh)"
