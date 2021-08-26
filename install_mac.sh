#!/bin/bash

# TODO dmgから
# awscliV2, Docker

# Install.
# which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install \
    awk \
    bat \
    gcc \
    gh \
    ghq \
    git \
    gnu-sed \
    jq \
    parquet-tools \
    peco \
    ripgrep \
    sops \
    starship \
    tfenv \
    tmux \
    tree \
    vim \
    watch \
    zplug \
    zsh
# brew upgrade

# tmux plugin.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Dotfiles.
DOTFILES=dotfiles
FILES=$(ls -1a ${DOTFILES} | grep -E "\.[^\.]+")
CD=$(cd $(dirname $0); pwd)/${DOTFILES}
for f in ${FILES}; do
    if [ ! -e ~/${f} ]; then
        echo "ln -s ${CD}/${f} ~/${f}"
        ln -sf ${CD}/${f} ~/${f}
    fi
done

# Settings
defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer
