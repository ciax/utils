#!/bin/bash
# Required commands: ping
# Required scripts: func.getpar, db-exec
# Required tables: host,hub,subnet
# Description: show network tree
. func.getpar

open_super(){
    connect[$1]="---$C2"
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read h u n; do
        u="${u:-$1}"
        sub[$u]="${sub[$u]},$h" # add itself to parent var
        super[$h]="$u"
        eval "title[$h]=$n$C0" # to remove '"'
        eval "$(db-trace $h hub subnet domain)"
        domain[$h]=$name
    done < <(db-exec "select id,super,description from hub where subnet == '$1';")
}

get_hosts(){
    for u in ${!title[*]};do
        while read h fdqn; do
            sub[$u]="${sub[$u]},$h"
            super[$h]="$u"
            title[$h]="$C4$h$C0"
            site="$h.${domain[$u]}"
            chk_host "$site" && open_super $h
        done < <(db-exec "select id,fdqn from host where hub == '$u';")
    done
}

show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    last=${sub[$1]##*,}
    local ind="$2   "
    for i in ${sub[$1]#*,};do
        echo "${ind}|${connect[$i]:--${C1}X-}${title[$i]}"$C0
        if [ "$i" = "$last" ];then
            show_tree $i "$ind "
        else
            show_tree $i "$ind|"
        fi
    done
}

chk_host(){ true; }

# Options
opt-p(){ #ping check
    echo -n "Checking ";nl=$'\n'
    chk_host(){
        echo -n '.'
        ping -c1 -w1 "$1" &>/dev/null
    }
}

### main ###
_usage "[subnet]" <(db-list subnet)

declare -A sub
declare -A super
declare -A title
declare -A domain
declare -A connect
IFS=','
get_hubs $1
get_hosts
echo "$nl $1"
show_tree $1
