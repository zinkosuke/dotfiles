#!/bin/bash

# https://brew.sh/index_ja
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
brew upgrade

FILES=$(cat <<EOF
.bashrc
.config
.gitconfig
.gitignore
.tmux.conf
.vimrc
.zshrc
EOF
)

CD=$(cd $(dirname $0); pwd)
for f in ${FILES}; do
    echo "ln -s ${CD}/${f} ~/${f}"
    ln -s ${CD}/${f} ~/${f}
done
