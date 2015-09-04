#!/bin/bash
# Required scripts: file-selflink
# Description: update git repositories
. func.msg
for i in ~/*/.git;do
    pushd $i >/dev/null
    cd ..
    _warn "Git update for $PWD"
    git remote update -p origin
    git pull
    popd >/dev/null
done
file-register $dirs
bashrc-setup
