#!/bin/bash
set -euo pipefail
cd "$(dirname "${0}")"

# TODO awscliV2

which brew || /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew update
brew install \
    age \
    awk \
    bat \
    docker \
    gcc \
    ghq \
    git \
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
