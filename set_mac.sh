#!/bin/bash
set -euxo pipefail
cd "$(dirname "${0}")"

# dotfiles.
FILES=$(ls -1a dotfiles | grep -E "\.[^\.]+")
for f in ${FILES}; do
    [ ! -e ~/${f} ] && ln -sf $(pwd)/dotfiles/${f} ~/${f}
done

# settings.
defaults write com.apple.screencapture location ~/Downloads
killall SystemUIServer
