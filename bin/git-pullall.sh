#!/bin/bash
# Required scripts: file-link
# Description: update git repositories
. func.getpar
xopt-b(){ main > /dev/null 2>&1 & }
main(){
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
}
_usage
main
