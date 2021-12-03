# Completion.
autoload -Uz compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Ignore case.
zstyle ':completion:*:default' menu select=1         # Enable arrow keys.
zstyle ':completion:*' ignore-parents parent pwd ..  # Ignore current dir.
zstyle ':completion:*:sudo:*' command-path $(echo ${PATH} | tr ':' ' ')  # sudo.
zmodload zsh/complist

# Delimiters.
autoload -Uz select-word-style; select-word-style default
zstyle ':zle:*' word-chars ' /=-;@:()[]{},.|'
zstyle ':zle:*' word-style unspecified
setopt extended_glob         # Enable extended notation e.g. ls test/^*.txt
setopt interactive_comments  # Comment in command line.

# Plugins.
case "$(uname)" in
    Darwin)
        export ZPLUG_HOME=/usr/local/opt/zplug
        ;;
    Linux)
        export ZPLUG_HOME=/home/linuxbrew/.linuxbrew/opt/zplug
        alias zplug='zplug-env'
        ;;
esac
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
# If following error occurred.
#   "zsh compinit: insecure directories, run compaudit for list."
# chmod g-w /usr/local/share/zsh

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

# Move dir.
export DIRSTACKSIZE=100
setopt auto_cd            # Don't have to type 'cd'.
setopt auto_pushd         # Stack up dir history.
setopt pushd_ignore_dups  # Ignore duplicates.

# Key binds (vim).
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Editor.
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less -N'

# Custom.
. ~/.aliases
. ~/.functions
eval "$(starship init zsh)"
case "$(uname)" in
    Darwin)
        ;;
    Linux)
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        ;;
esac

# AWS default.
export AWS_DEFAULT_OUTPUT=json
export AWS_DEFAULT_REGION=ap-northeast-1
