#!/bin/bash
set -eux

BAT_VERSION=0.20.0

curl -fLsS -o bat_amd64.deb \
    "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"

sudo dpkg -i bat_amd64.deb

rm bat_amd64.deb
