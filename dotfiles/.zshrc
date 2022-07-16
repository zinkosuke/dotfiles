. ~/.commonrc

export HISTFILE=~/.zsh_history

for zplug_home in $(cat <<EOF
/usr/local/opt/zplug
/usr/share/zplug
EOF
); do
    if [ -d ${zplug_home} ]; then
        export ZPLUG_HOME=${zplug_home}
        . ${ZPLUG_HOME}/init.zsh
        break
    fi
done
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

bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

zle -N peco_aws_profile
bindkey '^A' peco_aws_profile
zle -N peco_ghq_look
bindkey '^G' peco_ghq_look
zle -N peco_git_branch
bindkey '^B' peco_git_branch
zle -N peco_history
bindkey '^H' peco_history
zle -N peco_find
bindkey '^F' peco_find

chpwd() { l }

eval "$(starship init zsh)"
source <(kubectl completion zsh)
