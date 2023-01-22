#!/bin/bash
set -eux

function install_docker() {
    [ -e /usr/share/keyrings/docker-archive-keyring.gpg ] || curl -fLsS https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update && apt install -y --no-install-recommends \
        docker-ce docker-ce-cli containerd.io
    set +e; service docker start; set -e
}

function install_docker_compose() {
    DOCKER_COMPOSE_VERSION=1.29.2
    curl -fLsS -o /usr/local/bin/docker-compose \
        "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
    chmod +x /usr/local/bin/docker-compose
}

function install_kubectl() {
    KUBECTL_VERSION=v1.24.0
    curl -fLsS -o /usr/local/bin/kubectl \
        "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x /usr/local/bin/kubectl
}

function install_helm() {
    HELM_VERSION=v3.9.0
    mkdir helm && curl -fLsS \
        "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
        | tar -C helm -xz --strip-components 1
    mv helm/helm /usr/local/bin/
    rm -rf helm
}

function install_minikube() {
    curl -fLsS -o /usr/local/bin/minikube \
        "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
    chmod +x /usr/local/bin/minikube
}

function install_hadolint() {
    HADOLINT_VERSION=v2.9.3
    curl -fLsS -o /usr/local/bin/hadolint \
        "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64"
    chmod +x /usr/local/bin/hadolint
}

install_docker
install_docker_compose
install_kubectl
install_helm
install_minikube
install_hadolint
