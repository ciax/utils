#!/bin/bash
# Description: update all git branches
. func.getpar
xopt-b(){ main $* > /dev/null 2>&1 & }
main(){
    cd ${1:-.}
    git fetch
    for i in $(git branch|sort|tr -d '*'); do
        git checkout $i
        git pull
    done
}
_usage "(dir)"
main $*

