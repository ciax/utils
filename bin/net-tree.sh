#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
_usage "[subnet]" $1 < <(db-list subnet)

subtree(){
    [ $depth -gt  10 ] && { echo "Infinity Loop error"; exit 1; }
    depth=$(( $depth + 1 ))
    local ind="   |$2"
    for i in ${sub[$1]};do
        echo "${ind}-${title[$i]}"
        subtree $i "$ind"
    done
    depth=$(( $depth - 1 ))
}

declare -A sub
declare -A title
IFS='|'
while read h u n; do
    u="${u:-$1}"
    sub[$u]="${sub[$u]}$h|"
    title[$h]=$C5"$n"$C0
done < <(db-register "select id,upper,description from hub where subnet == '$1';")
for u in ${!title[*]};do
    while read h; do
        sub[$u]="${sub[$u]}$h|"
        title[$h]="($h)"
    done < <(db-register "select host from mac where hub == '$u';")
done
depth=0
echo " $1"
subtree $1
