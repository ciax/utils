#!/bin/bash
# Description: show network tree
# Required scripts: rc.app, db-register
# Required tables: mac,hub,subnet
. rc.app

open_super(){
    connect[$1]=1
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read h u n; do
        u="${u:-$1}"
        sub[$u]="${sub[$u]}$h|" # add itself to parent var
        super[$h]="$u"
        title[$h]=$C2"$n"$C0
    done < <(db-register "select id,super,description from hub where subnet == '$1';")
}

get_hosts(){
    for u in ${!title[*]};do
        while read h; do
            sub[$u]="${sub[$u]}$h|"
            super[$h]="$u"
            title[$h]="("$C4"$h"$C0")"
            chk_host $h && open_super $h
        done < <(db-register "select host from mac where hub == '$u';")
    done
}

show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    local ind="    |$2"
    for i in ${sub[$1]};do
        if [ "${connect[$i]}" ];then
            echo "${ind}---${title[$i]}"
        else
            echo "${ind}-${C1}X$C0-${title[$i]}"
        fi
        show_tree $i "$ind"
    done
}

chk_host(){ true; }

# Options
opt-p(){
    chk_host(){
        _progress "Checking"
        ping -c1 -w1 $1 &>/dev/null
    }
}

### main ###
_chkarg $(db-list subnet)
_usage "(-p:ping check) [subnet]"
set - $ARGV

declare -A sub
declare -A super
declare -A title
declare -A connect
IFS='|'
get_hubs $1
get_hosts
echo
echo " $1"
show_tree $1
