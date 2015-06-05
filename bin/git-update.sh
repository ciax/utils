#!/bin/bash
# Required scripts: git-dirs file-selflink
# Description: update git repositories
. func.msg
dirs="$(git-dirs)"
for i in $dirs;do
    _warn "Git update for $i"
    pushd $i >/dev/null
    git pull
    popd >/dev/null
done
file-register $dirs
