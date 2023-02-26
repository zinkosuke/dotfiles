#!/bin/bash
set -euo pipefail
cd "$(dirname "${0}")"

# TODO dmg: awscliV2, Docker, gcloud

which brew || /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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
    peco \
    ripgrep \
    shellcheck \
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
[ -d "${tpm_dir}" ] || git clone https://github.com/tmux-plugins/tpm "${tpm_dir}"

# settings.
defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer
