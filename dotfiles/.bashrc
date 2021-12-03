# History.
export HISTFILE=${HOME}/.bash_history
export HISTSIZE=1000
export SAVEHIST=1000

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
