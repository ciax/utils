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
        sup="${sup:-$1}"
        sub[$sup]+="|$self" # add itself to parent var
        super[$self]="$sup"
        [ "$wire" = opt ] && fiber[$self]=true
        title[$self]="$desc"
        eval $(db-trace $self hub subnet)
    done < <(db-exec "select id,super,wire,description from hub where subnet == '$1';"|sort)
    network=${network%.0}
}

get_hosts(){
    for sup in ${!title[*]};do
        while read self host_ip; do
            sub[$sup]+="|$self:"
            super[$self:]="$sup"
            title[$self:]="$self"
            if [ "$host_ip" ] ; then
                site="$network.$host_ip"
            else
                site="$self"
            fi
            ${cmd:-true} "$site" && open_super $self:
        done < <(db-exec "select id,host_ip from host where hub == '$sup';")
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

chk_host(){
    echo -n '.'
    ping -c1 -w1 "$1" &>/dev/null
}

# Options
opt-p(){ echo -n "Checking ";nl=$'\n';cmd="chk_host"; } #ping check

### main ###
_usage "[subnet]" < <(db-list subnet)
_exe_opt
declare -A sub
declare -A super
declare -A title
declare -A fiber
declare -A connect
IFS='|'
for i;do
    get_hubs $i
done
get_hosts
echo -n "$nl"
for i;do
    echo " $i"
    show_tree $i
done
