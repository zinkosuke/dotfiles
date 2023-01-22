#!/bin/bash
#
# Git pull all ghq repositories.
#
set -euo pipefail
cd "$(dirname "${0}")"

function git_pull() {
    # TODO forked
    set -eu
    cd "$(ghq root)/${1}"
    default_branch=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
    git fetch --prune origin > /dev/null 2>&1
    echo "${1} | $(git pull origin "${default_branch}:${default_branch}" 2>&1)"
}

export -f git_pull

ghq list | sort | xargs -I% -n1 -P5 bash -c "git_pull %"
