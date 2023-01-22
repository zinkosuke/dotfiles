. ~/.commonrc

export HISTFILE=~/.bash_history

eval "$(starship init bash)"
. <(kubectl completion zsh)
. "${HOME}/.asdf/asdf.sh"
