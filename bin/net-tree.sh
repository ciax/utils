#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
_usage "[subnet]" $1 < <(db-list subnet)

open_upper(){
    stat[$1]="---"
    local up="${upper[$1]}"
    [ "$up" ] && open_upper "$up"
}

gethubs(){
    while read h u n; do
        u="${u:-$1}"
        sub[$u]="${sub[$u]}$h|" # add itself to parent var
        upper[$h]="$u"
        title[$h]=$C2"$n"$C0
        stat[$h]=-$C1"X"$C0- # default status is disconnect
    done < <(db-register "select id,upper,description from hub where subnet == '$1';")
}

gethosts(){
    for u in ${!title[*]};do
        while read h; do
            sub[$u]="${sub[$u]}$h|"
            upper[$h]="$u"
            title[$h]="("$C4"$h"$C0")"
            if chkhost $h; then
                open_upper $h
            else
                stat[$h]=-$C1"X"$C0-
            fi
        done < <(db-register "select host from mac where hub == '$u';")
    done
}

subtree(){
    [ $depth -gt  10 ] && _abort "Infinite Loop Error"
    depth=$(( $depth + 1 ))
    local ind="    |$2"
    for i in ${sub[$1]};do
        echo "${ind}${stat[$i]}${title[$i]}"
        subtree $i "$ind"
    done
    depth=$(( $depth - 1 ))
}

chkhost(){ echo -n '.';ping -c1 -w1 $1 &>/dev/null; }

declare -A sub
declare -A upper
declare -A title
declare -A stat
IFS='|'
depth=0
gethubs $1
echo -n "Checking "
gethosts
echo
echo " $1"
subtree $1
