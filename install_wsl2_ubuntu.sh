#!/bin/bash
set -euxo pipefail
cd "$(dirname "${0}")"

export "USER=${SUDO_USER:-$USER}"
export "USER_HOME=$(getent passwd "${USER}" | cut -d: -f 6)"
export "USER_GRP=$(getent group "${USER}" | cut -d: -f 3)"

function apt_install() {
    sudo apt update
    sudo apt install -y --no-install-recommends \
        bat \
        build-essential \
        git \
        jq \
        keychain \
        make \
        peco \
        postgresql-client \
        ripgrep \
        shellcheck \
        tmux \
        tree \
        unzip \
        vim \
        watch \
        zip \
        zplug \
        zsh \
    && true
}
# apt_install

function install_tmux_plugin() {
    rm -rf "${USER_HOME}/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "${USER_HOME}/.tmux/plugins/tpm"

    add-apt-repository ppa:greymd/tmux-xpanes
    apt update
    apt install tmux-xpanes
}
# install_tmux_plugin

./scripts/install/awscli.sh
./scripts/install/bat.sh
./scripts/install/docker.sh
./scripts/install/gcloud.sh
./scripts/install/gh.sh
./scripts/install/ripgrep.sh
./scripts/install/sops.sh
./scripts/install/starship.sh
./scripts/install/tfenv.sh
# golang
./scripts/install/golang.sh
./scripts/install/age.sh
./scripts/install/ghq.sh

# XXX permissions.
# # docker.
# sudo usermod -aG docker "${USER}"
# # zplug.
# chgrp -R "${USER_GRP}" /usr/share/zplug
# chmod -R g+w /usr/share/zplug
