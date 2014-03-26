#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
subtree(){
    local ind="   |$2"
    for i in ${sub[$1]};do
        echo "$ind"
        echo -n "${ind}-- "
        db-register "select description from hub where id == '$i';"
        subtree $i "$ind"
    done
}

_usage "[subnet]" $1 < <(db-list subnet)
declare -A sub
for hub in $(db-register "select id,upper from hub where subnet == '$1';"); do
    up="${hub#*|}"
    hub="${hub%|*}"
    up=${up:-$1}
    sub[$up]="${sub[$up]} $hub"
done
echo "$1"
subtree $1
