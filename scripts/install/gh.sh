#!/bin/bash
set -eux

GH_VERSION=2.12.1

mkdir gh
curl -fLsS \
    "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
| tar -C gh -xz --strip-components 1

sudo mv gh/bin/gh /usr/local/bin

rm -rf gh
