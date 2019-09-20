# Alias.
. ~/.zsh_alias

# Completion.
autoload -Uz compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Ignore case.
zstyle ':completion:*:default' menu select=1  # Enable arrow keys.
zstyle ':completion:*' ignore-parents parent pwd ..  # Ignore current dir.
zstyle ':completion:*:sudo:*' command-path $(echo ${PATH} | tr ':' ' ')  # sudo.
zmodload zsh/complist

# Plugins.
. /usr/local/opt/zplug/init.zsh
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting'
if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose

# History.
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
setopt hist_ignore_all_dups  # Ignore duplicates.
setopt hist_ignore_space     # Ignore if command starts with space.
setopt hist_no_store         # Ignore `history` command.
setopt hist_reduce_blanks    # Reduce white space.
setopt hist_verify           # After selecting a history, wait before execution.
setopt inc_append_history    # Add history incrementally.
setopt share_history         # Share history on multiple terminal.
function peco-inc-history() {
    BUFFER=$(history -n 1 | tail -r | awk '!a[$0]++' | peco)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-inc-history
bindkey '^R' peco-inc-history

# Delimiters.
autoload -Uz select-word-style; select-word-style default
    zstyle ':zle:*' word-chars ' /=-;@:()[]{},.|'
zstyle ':zle:*' word-style unspecified
setopt extended_glob         # Enable extended notation e.g. ls test/^*.txt
setopt interactive_comments  # Comment in command line.

# Key binds (vim).
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Move dir.
export DIRSTACKSIZE=100
setopt auto_cd            # Don't have to type 'cd'.
setopt auto_pushd         # Stack up dir history.
setopt pushd_ignore_dups  # Ignore duplicates.

# Editor.
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less -N'

# Peco search.
function p() {
    case "${1}" in
        aws)
            export AWS_PROFILE=$(grep '^\[' ~/.aws/credentials | tr -d '[]'| peco)
            ;;
        git)
            cd $(ghq root)/$(ghq list | peco)
            ;;
        ssh)
            ssh $(grep 'Host ' ~/.ssh/config | grep -Fv '*' | cut -d' ' -f 2 | peco)
            ;;
    esac
}

# Reload this file.
function rl() {
    echo "Reload shell ${SHELL}"
    exec ${SHELL} -l
}

# Starship.
function show_aws_profile() {
    PR_AWS=''
    if [ "${AWS_PROFILE}" != "" ]; then
        PR_AWS="🌩  AWS[${AWS_PROFILE}]"
    fi
    echo "${PR_AWS}"
}
precmd_functions+=('show_aws_profile')
eval "$(starship init zsh)"

# Show colors.
# for c in {000..255}; do
#     echo -n "\e[38;5;${c}m $c"
#     [ $(($c%16)) -eq 15 ] && echo
# done; echo
