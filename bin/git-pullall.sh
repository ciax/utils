#!/bin/bash
# Required scripts: file-link
# Description: pull all the git repositories
. func.msg
for i in $(git-dirs);do
    pushd $i >/dev/null
    _warn "Git pull for $PWD"
    git remote update -p origin
    git-pull
    popd >/dev/null
done
cd ~/bin
file-clean
