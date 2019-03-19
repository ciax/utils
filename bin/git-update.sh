#!/bin/bash
# Required scripts: link-self
# Description: update git repositories
. func.msg
for i in ~/*/.git/COMMIT_EDITMSG;do
    pushd ${i%/.git*} >/dev/null
    _warn "Git update for $PWD"
    git remote update -p origin
    git pull
    dir="$dir $PWD"
    popd >/dev/null
done
cd ~/bin
file-clean
