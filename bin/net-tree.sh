#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
_usage "[subnet]" $1 < <(db-list subnet)

gethubs(){
    while read h u n; do
        u="${u:-$1}"
        sub[$u]="${sub[$u]}$h|"
        title[$h]=$C2"$n"$C0
        stat[$h]=-$C1"X"$C0-
    done < <(db-register "select id,upper,description from hub where subnet == '$1';")
}

gethosts(){
    for u in ${!title[*]};do
        while read h; do
            h="($h)"
            sub[$u]="${sub[$u]}$h|"
            title[$h]=$C4"$h"$C0
            if chkhost; then
                stat[$h]="---"
                stat[$u]="---"
            else
                stat[$h]=-$C1"X"$C0-
            fi
        done < <(db-register "select host from mac where hub == '$u';")
    done
}

subtree(){
    [ $depth -gt  10 ] && { echo "Infinity Loop error"; exit 1; }
    depth=$(( $depth + 1 ))
    local ind="    |$2"
    for i in ${sub[$1]};do
        echo "${ind}${stat[$i]}${title[$i]}"
        subtree $i "$ind"
    done
    depth=$(( $depth - 1 ))
}

chkhost(){ true; }

declare -A sub
declare -A title
declare -A stat
IFS='|'
gethubs $1
gethosts
depth=0
echo " $1"
subtree $1
