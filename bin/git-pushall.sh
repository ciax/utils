#!/bin/bash
# Description: push to all the git repositories
. func.msg
for i in $(git-dirs);do
    pushd $i >/dev/null
    _title "Git push for $PWD"
    git config credential.helper store
    git-push
    popd >/dev/null
done
