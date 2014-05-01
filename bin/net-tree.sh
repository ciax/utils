#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host hub subnet
# Description: show network tree
. func.getpar

open_super(){
    connect[$1]=true
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read self sup wire desc; do
        sup="${sup:-top}"
        sub[$sup]+="|$self" # add itself to parent var
        super[$self]="$sup"
        [ "$wire" = opt ] && fiber[$self]=true
        title[$self]="$desc"
        eval $(db-trace $self hub subnet)
    done < <(db-exec "select id,super,wire,description from hub where subnet == '$1';"|sort)
}

get_hosts(){
    for sup in ${!title[*]};do
        while read self static_ip; do
            sub[$sup]+="|$self:"
            super[$self:]="$sup"
            title[$self:]="$self"
            site="${static_ip:-$self}"
            chk_host "$site" && open_super $self:
        done < <(db-exec "select id,static_ip from host where hub == '$sup';")
    done
}

show_tree(){
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    last="${sub[$1]##*|}"
    local ind="$2   "
    for i in ${sub[$1]#*|};do
        echo -n "${ind}|"
        if [ "${fiber[$i]}" ] ; then
            c='='
            echo -n $C3
        else
            c='-'
        fi
        if [ "${connect[$i]}" ] ; then
            echo -n "$c$c$c"
            [[ $i == *: ]] && echo -n $C4 || echo -n $C2
        else
            echo -n "$c${C1}X$c"
        fi
        echo "${title[$i]}"$C0
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
declare -A fiber
declare -A connect
IFS='|'
get_hubs $1
get_hosts
echo "$nl $1"
show_tree top
