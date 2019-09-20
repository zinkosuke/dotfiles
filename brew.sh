#!/bin/bash

# https://brew.sh/index_ja
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew install \
    awk \
    ghq \
    git \
    jq \
    vim \
    peco \
    tmux \
    tree \
    starship \
    watch \
    zsh \
    zplug

CD=$(cd $(dirname $0); pwd)
FILES=$(cat <<EOF
.gitconfig
.gitignore
.tmux.conf
.vimrc
.zshrc
EOF
)

for f in ${FILES}; do
    echo "ln -s ${CD}/${f} ~/${f}"
    ln -s ${CD}/${f} ~/${f}
done

mkdir -p ~/.config
f=starship.toml
echo "ln -s ${CD}/${f} ~/.config/${f}"
ln -s ${CD}/${f} ~/.config/${f}
