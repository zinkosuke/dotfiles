. ~/.alias
export HISTFILE=~/.bash_history
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

eval "$(starship init bash)"
