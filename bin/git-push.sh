#!/bin/bash
# Required scripts: git-dirs
# Description: push to git repositories
. func.msg
for i in $(git-dirs);do
    _warn "Git push for $i"
    pushd $i >/dev/null
    git config credential.helper store
    git push
    popd >/dev/null
done
