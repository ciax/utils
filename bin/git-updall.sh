#!/bin/bash
# Description: update all git branches
. func.getpar
xopt-b(){ main $* > /dev/null 2>&1 & }
main(){
    cd ${1:-.}
    git fetch
    crnt=$(git branch --contains|cut -d' ' -f2)
    others="$(git branch|grep -v '*')"
    for i in $others $crnt; do
        git checkout $i
        git pull
    done
}
_usage "(dir)"
main $*

