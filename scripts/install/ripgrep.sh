#!/bin/bash
set -eux

RIPGREP_VERSION=13.0.0

curl -fLsS -o ripgrep_amd64.deb \
    "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"

sudo dpkg -i ripgrep_amd64.deb

rm ripgrep_amd64.deb
