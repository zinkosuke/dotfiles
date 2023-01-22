#!/bin/bash
set -eux

# rm -rf "${HOME}/.config/gcloud"
sudo rm -rf /usr/local/gcloud

curl -fLsS -o gcloud.tar.gz \
    https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-370.0.0-linux-x86_64.tar.gz

sudo mkdir -p /usr/local/gcloud
sudo tar -C /usr/local/gcloud -xvf gcloud.tar.gz
sudo /usr/local/gcloud/google-cloud-sdk/install.sh -q

rm gcloud.tar.gz
