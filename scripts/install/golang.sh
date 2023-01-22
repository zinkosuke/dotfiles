#!/bin/bash
set -eux

GO_VERSION=1.17.5

sudo rm -rf /usr/local/go
sudo rm -rf /usr/local/bin/go
sudo rm -rf /usr/local/bin/gofmt

curl -fLsS "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
| sudo tar -C /usr/local -xz

sudo ln -sf /usr/local/go/bin/go /usr/local/bin/
sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/

# export "GOPATH=${HOME}/go"
# export "PATH=$PATH:${GOPATH}/bin"
