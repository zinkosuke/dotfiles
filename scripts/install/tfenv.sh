#!/bin/bash
set -eux

rm -rf "${HOME}/.tfenv"
sudo rm -rf /usr/local/bin/terraform
sudo rm -rf /usr/local/bin/tfenv

git clone https://github.com/tfutils/tfenv.git "${HOME}/.tfenv"

sudo ln -sf "${HOME}/.tfenv/bin/tfenv" /usr/local/bin/
sudo ln -sf "${HOME}/.tfenv/bin/terraform" /usr/local/bin/
