#!/bin/bash
#
# Git pull all ghq repositories.
#
set -eu
base_dir=$(cd $(dirname ${0}); pwd)

function git_pull() {
    # TODO forked
    set -eu
    cd "$(ghq root)/${1}"
    default_branch=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
    git fetch --prune origin 2>&1 > /dev/null
    echo "${1} | $(git pull origin ${default_branch}:${default_branch} 2>&1)"
}

export -f git_pull

ghq list | grep -v added | xargs -I% -n1 -P5 bash -c "git_pull %"
