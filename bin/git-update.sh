#!/bin/bash
# Required scripts: git-dirs,file-register
# Description: update git repositories
cd
for i in $(git-dirs);do
    echo $C3"Git update for $i"$C0
    pushd $i >/dev/null
    git pull
    popd >/dev/null
done
file-register
