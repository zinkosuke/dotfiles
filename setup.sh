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
    zsh

CD=$(cd $(dirname $0); pwd)

for fn in $(ls -1aF | grep '^\.' | grep -v '\/$' | grep -v swp); do
    echo "ln -s ${CD}/${fn} ~/${fn}"
    ln -s ${CD}/${fn} ~/${fn}
done
