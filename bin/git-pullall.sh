#!/bin/bash
# Required scripts: file-link
# Description: pull all the git repositories
. func.msg
for i in $(git-dirs);do
    pushd $i >/dev/null
    _title "Git pull for $PWD"
    git remote update -p origin
    git pull --all
    popd >/dev/null
done
file-clean
