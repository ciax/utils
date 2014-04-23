#!/bin/bash
# Required scripts: git-dirs
# Description: push to git repositories
for i in $(git-dirs);do
    echo $C3"Git push for $i"$C0
    pushd $i >/dev/null
    git config credential.helper store
    git push
    popd >/dev/null
done
