#!/bin/bash
# Description: push to git repositories
. func.msg
for i in ~/*/.git/COMMIT_EDITMSG;do
    pushd ${i%/.git*} >/dev/null
    _warn "Git push for $PWD"
    git config credential.helper store
    git push
    popd >/dev/null
done
