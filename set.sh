#!/bin/bash
set -euo pipefail
cd "$(dirname "${0}")"

dotfiles=dotfiles

if [[ ! -d ${dotfiles} ]]; then
    echo "Not exists ./${dotfiles}"
    exit 1
fi

for f in dotfiles/.*; do
    [[ ${f: -1} = '.' ]] && continue
    # rm -f ~/${f}
    if [[ -e ${HOME}/${f} ]]; then
        echo "Exists: (skip) ${HOME}/${f}"
    else
        echo "Link: ${HOME}/${f}"
        ln -sf "$(pwd)/${dotfiles}/${f}" "${HOME}/${f}"
    fi
done
