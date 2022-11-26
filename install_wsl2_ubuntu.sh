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
sh -c "$(curl -fLsS https://starship.rs/install.sh)"

# ripgrep.
RIPGREP_VERSION=13.0.0
curl -fLsS -o ripgrep_amd64.deb \
    "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
dpkg -i ripgrep_amd64.deb
rm ripgrep_amd64.deb

# bat.
BAT_VERSION=0.20.0
curl -fLsS -o bat_amd64.deb \
    "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"
dpkg -i bat_amd64.deb
rm bat_amd64.deb

# gh.
GH_VERSION=2.12.1
mkdir gh && curl -fLsS \
    "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
    | tar -C gh -xz --strip-components 1
mv gh/bin/gh /usr/local/bin
rm -rf gh

# tmux plugins.
rm -rf ${USER_HOME}/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ${USER_HOME}/.tmux/plugins/tpm

# docker.
[ -e /usr/share/keyrings/docker-archive-keyring.gpg ] || curl -fLsS https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && apt install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io
set +e; service docker start; set -e

# docker-compose.
DOCKER_COMPOSE_VERSION=1.29.2
curl -fLsS -o /usr/local/bin/docker-compose \
    "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose

# kubectl.
KUBECTL_VERSION=v1.24.0
curl -fLsS -o /usr/local/bin/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl

# helm.
HELM_VERSION=v3.9.0
mkdir helm && curl -fLsS \
    "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    | tar -C helm -xz --strip-components 1
mv helm/helm /usr/local/bin/
rm -rf helm

# minikube.
curl -fLsS -o /usr/local/bin/minikube \
    "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
chmod +x /usr/local/bin/minikube

# hadolint.
HADOLINT_VERSION=v2.9.3
curl -fLsS -o /usr/local/bin/hadolint \
    "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64"
chmod +x /usr/local/bin/hadolint

# golang.
GO_VERSION=1.17.5
rm -rf \
    /usr/local/go \
    /usr/local/bin/go \
    /usr/local/bin/gofmt
curl -fLsS "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
    | tar -C /usr/local -xz
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
curl -fLsS -o /usr/local/bin/sops \
    "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux"
chmod +x /usr/local/bin/sops

# awscliV2.
rm -rf \
    /usr/local/aws-cli \
    /usr/local/bin/aws \
    /usr/local/bin/aws_completer
curl -fLsS -o awscliv2.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# gcloud.
rm -rf /usr/local/gcloud
rm -rf ${USER_HOME}/.config/gcloud
curl -fLsS -o gcloud.tar.gz \
    "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-370.0.0-linux-x86_64.tar.gz"
mkdir -p /usr/local/gcloud
tar -C /usr/local/gcloud -xvf gcloud.tar.gz
/usr/local/gcloud/google-cloud-sdk/install.sh -q
rm gcloud.tar.gz

# tfenv.
rm -rf \
    ${USER_HOME}/.tfenv \
    /usr/local/bin/terraform \
    /usr/local/bin/tfenv
git clone https://github.com/tfutils/tfenv.git ${USER_HOME}/.tfenv
ln -sf ${USER_HOME}/.tfenv/bin/tfenv /usr/local/bin/
ln -sf ${USER_HOME}/.tfenv/bin/terraform /usr/local/bin/

# tfnotify.
TFNOTIFY_VERSION=0.7.5
mkdir -p tfnotify
curl -fLsS -o tfnotify/tfnotify.tar.gz \
    "https://github.com/mercari/tfnotify/releases/download/v${TFNOTIFY_VERSION}/tfnotify_linux_amd64.tar.gz"
tar -C tfnotify -zxvf tfnotify/tfnotify.tar.gz
mv tfnotify/tfnotify /usr/local/bin/
rm -rf tfnotify

# XXX permissions.
# docker.
sudo usermod -aG docker ${USER}
# zplug.
chgrp -R ${USER_GRP} /usr/share/zplug
chmod -R g+w /usr/share/zplug
