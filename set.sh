#!/bin/bash
set -euo pipefail
cd "$(dirname "${0}")"

dotfiles=dotfiles

if [[ ! -d ${dotfiles} ]]; then
    echo "Not exists ./${dotfiles}"
    exit 1
fi

for f in dotfiles/.*; do
    f=$(basename "${f}")
    [[ ${f: -1} = '.' ]] && continue
    if [[ -e ${HOME}/${f} ]]; then
        echo "Exists: (skip) ${HOME}/${f}"
        continue
        # rm -f ~/${f}
    fi
    echo "Link: ${HOME}/${f}"
    ln -sf "$(pwd)/${dotfiles}/${f}" "${HOME}/${f}"
done
