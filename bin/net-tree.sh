#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host hub subnet
# Description: show network tree
. func.getpar

open_super(){
    connect[$1]="---${2:-$C2}"
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read crh sup desc; do
        sup="${sup:-top}"
        sub[$sup]+="|$crh" # add itself to parent var
        super[$crh]="$sup"
        title[$crh]=$desc$C0
        eval $(db-trace $crh hub subnet)
    done < <(db-exec "select id,super,description from hub where subnet == '$1';"|sort)
}

get_hosts(){
    for sup in ${!title[*]};do
        while read hst static_ip; do
            sub[$sup]+="|$hst:"
            super[$hst:]="$sup"
            title[$hst:]="$hst$C0"
            site="${static_ip:-$hst}"
            chk_host "$site" && open_super $hst: "$C4"
        done < <(db-exec "select id,static_ip from host where hub == '$sup';")
    done
}

show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    last="${sub[$1]##*|}"
    local ind="$2   "
    for i in ${sub[$1]#*|};do
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
declare -A connect
IFS='|'
get_hubs $1
get_hosts
echo "$nl $1"
show_tree top
