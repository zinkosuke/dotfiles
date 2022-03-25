#!/bin/bash
set -euxo pipefail
cd "$(dirname "${0}")"

# TODO parquet-tools
USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd ${USER} | cut -d: -f 6)
USER_GRP=$(getent group ${USER} | cut -d: -f 3)

apt update && apt install -y --no-install-recommends \
    bat \
    build-essential \
    git \
    jq \
    keychain \
    make \
    peco \
    postgresql-client \
    ripgrep \
    tmux \
    tree \
    unzip \
    vim \
    watch \
    zip \
    zplug \
    zsh \
&& echo 'Install done!'

# starship.
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

# ripgrep.
RIPGREP_VERSION=13.0.0
curl -fsSL -o ripgrep_amd64.deb \
    "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
dpkg -i ripgrep_amd64.deb
rm ripgrep_amd64.deb

# bat.
BAT_VERSION=0.20.0
curl -fsSL -o bat_amd64.deb \
    "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
dpkg -i bat_amd64.deb
rm bat_amd64.deb

# tmux plugins.
rm -rf ${USER_HOME}/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ${USER_HOME}/.tmux/plugins/tpm

# docker.
[ -e /usr/share/keyrings/docker-archive-keyring.gpg ] || curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io
set +e; service docker start; set -e

# docker-compose.
DOCKER_COMPOSE_VERSION=1.29.2
curl -fsSL -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose

# hadolint.
HADOLINT_VERSION=2.9.3
curl -fsSL -o /usr/local/bin/hadolint \
    "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64"
chmod +x /usr/local/bin/hadolint

# golang.
GO_VERSION=1.17.5
rm -rf \
    /usr/local/go \
    /usr/local/bin/go \
    /usr/local/bin/gofmt
curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
ln -sf /usr/local/go/bin/go /usr/local/bin/
ln -sf /usr/local/go/bin/gofmt /usr/local/bin/
export GOPATH=${USER_HOME}/go
export "PATH=$PATH:${GOPATH}/bin"
# age.
go install filippo.io/age/cmd/...@latest
# ghq.
go install github.com/x-motemen/ghq@latest

# sops.
SOPS_VERSION=v3.7.1
curl -fsSL -o /usr/local/bin/sops \
    "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux"
chmod +x /usr/local/bin/sops

# awscliV2.
rm -rf \
    /usr/local/aws-cli \
    /usr/local/bin/aws \
    /usr/local/bin/aws_completer
curl -fsSL -o awscliv2.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# tfenv.
rm -rf \
    ${USER_HOME}/.tfenv \
    /usr/local/bin/terraform \
    /usr/local/bin/tfenv
git clone https://github.com/tfutils/tfenv.git ${USER_HOME}/.tfenv
ln -sf ${USER_HOME}/.tfenv/bin/tfenv /usr/local/bin/
ln -sf ${USER_HOME}/.tfenv/bin/terraform /usr/local/bin/

# XXX permissions.
# docker.
sudo usermod -aG docker ${USER}
# zplug.
chgrp -R ${USER_GRP} /usr/share/zplug
chmod -R g+w /usr/share/zplug
