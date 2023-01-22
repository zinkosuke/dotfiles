#!/bin/bash
set -eux

sudo rm -rf /usr/local/aws-cli
sudo rm -rf /usr/local/bin/aws
sudo rm -rf /usr/local/bin/aws_completer

curl -fLsS -o awscliv2.zip \
    https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

unzip awscliv2.zip
sudo ./aws/install

rm -rf awscliv2.zip aws
