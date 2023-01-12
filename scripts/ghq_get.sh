#!/bin/bash
#
# ghq get repositories.
#
set -euo pipefail
base_dir=$(cd $(dirname ${0}); pwd)

alias ghq=~/go/bin/ghq

function ghq_get () {
    # e.g. git@github.com:zinkosuke/dotfiles.git
    ghq get "${1}"
}

export -f ghq_get

cat "${base_dir}/.repolist" | xargs -I% -n1 -P5 bash -c "ghq_get %"

# TODO forked
# for upstream in $(cat <<EOF
# https://github.com/encode/django-rest-framework.git
# EOF
# ); do
#     target=git@github.com/zinkosuke/${upstream##*/}
#     ~/go/bin/ghq get ${target}
#     cd ${ghq_root}/$(echo ${target} | sed -e's/git@\(.*\)\.git/\1/g')
#     if [ $(git remote | grep up | wc -l) -eq 0 ]; then
#         git remote add up ${upstream}
#         git remote set-url --push up no-pushing
#     fi
#     git remote -v
# done
