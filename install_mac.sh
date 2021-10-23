#!/bin/bash
set -euxo pipefail
cd "$(dirname "${0}")"

# TODO dmgから
# awscliV2, Docker

# install.
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install \
    age \
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
brew upgrade

# tmux.
tpm_dir=~/.tmux/plugins/tpm
[ -d "${tpm_dir}" ] || git clone https://github.com/tmux-plugins/tpm ${tpm_dir}
