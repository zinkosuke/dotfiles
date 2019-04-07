#!/bin/bash

CD=$(cd $(dirname $0); pwd)

for fn in $(ls -1aF | grep '^\.' | grep -v '\/$' | grep -v swp); do
    echo "ln -s ${CD}/${fn} ~/${fn}"
    ln -s ${CD}/${fn} ~/${fn}
done
