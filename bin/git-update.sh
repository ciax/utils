#!/bin/bash
# Required scripts: git-dirs,file-register
# Description: update git repositories
for i in $(git-dirs);do
    echo $C3"Git update for $i"$C0
    pushd $i >/dev/null
    git pull
    file-register
    popd >/dev/null
done
