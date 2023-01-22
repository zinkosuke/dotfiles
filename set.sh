#!/bin/bash
set -euo pipefail
cd "$(dirname "${0}")"

# target=${1}
# dotfiles=${target}_dotfiles
dotfiles=dotfiles

if [[ ! -d ${dotfiles} ]]; then
    echo "Not exists ./${dotfiles}"
    exit 1
fi

FILES=$(ls -1a "${dotfiles}" | grep -E '\.[^\.]+')
for f in ${FILES}; do
    # rm -f ~/${f}
    if [[ -e ${HOME}/${f} ]]; then
        echo "Exists: (skip) ${HOME}/${f}"
    else
        echo "Link: ${HOME}/${f}"
        ln -sf "$(pwd)/${dotfiles}/${f}" "${HOME}/${f}"
    fi
done
