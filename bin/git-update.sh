#!/bin/bash
# Required scripts: git-dirs file-linkbin
# Description: update git repositories
dirs="$(git-dirs)"
for i in $dirs;do
    echo $C3"Git update for $i"$C0
    pushd $i >/dev/null
    git pull
    popd >/dev/null
done
file-clean ~/bin
file-linkbin $dirs
