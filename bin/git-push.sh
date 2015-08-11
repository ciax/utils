#!/bin/bash
# Description: push to git repositories
. func.msg
for i in ~/*/.git;do
    pushd $i >/dev/null
    cd ..
    _warn "Git push for $PWD"
    git config credential.helper store
    git push
    popd >/dev/null
done
