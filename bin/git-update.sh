#!/bin/bash
# Required scripts: link-self
# Description: update git repositories
. func.msg
echo "args $*"
for i in ~/utils ${*:-~/cfg.*};do
    pushd $i >/dev/null
    _warn "Git update for $PWD"
    git remote update -p origin
    git pull
    dir="$dir $PWD"
    popd >/dev/null
done
cd ~/bin
file-clean
