#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
subtree(){
    local ind="   |$2"
    for i in ${sub[$1]};do
        echo "${ind}"
        echo "${ind}-${title[$i]}"
        subtree $i "$ind"
    done
}

_usage "[subnet]" $1 < <(db-list subnet)
declare -A sub
declare -A title
IFS='|'
while read h u n; do
    u="${u:-$1}"
    sub[$u]="${sub[$u]}$h|"
    title[$h]="$n"
done < <(db-register "select id,upper,description from hub where subnet == '$1';")
echo " $1"
subtree $1
