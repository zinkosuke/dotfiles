#!/bin/bash
set -eux

SOPS_VERSION=v3.7.1

curl -fLsS -o sops \
    "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux"

sudo mv sops /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops
