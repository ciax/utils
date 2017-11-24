#!/bin/bash
# Required packages: nmap
# Required scripts: func.getpar func.temp db-exec
# Required tables: host hub subnet
# Description: show network tree
. func.getpar

open_super(){
    connect[$1]=true
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read self_hub sup wire desc host; do
        sup="${sup:-$1}"
        sub[$sup]+="|$self_hub" # add itself to parent var
        super[$self_hub]="$sup"
        [ "$wire" = opt ] && fiber[$self_hub]=true
        title[$self_hub]="$desc${host:+ $C4($host)}"
        eval $(db-trace $self_hub hub subnet)
    done < <(db-exec "select id,super,wire,description,host from hub where subnet == '$1';"|sort)
    network=${network%.0}
}

get_hosts(){
    for sup in ${!title[*]};do
        while read self_host host_ip; do
            sub[$sup]+="|$self_host:"
            super[$self_host:]="$sup"
            title[$self_host:]="$self_host"
            ${cmd:-true} && open_super $self_host:
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
            echo -n "$c${D1}X$c"
        fi
        echo "${title[$i]}"$C0
        # Recursive call
        if [ "$i" = "$last" ];then
            show_tree $i "$ind "
        else
            show_tree $i "$ind|"
        fi
    done
}

top_tree(){
    eval $(db-trace $1 subnet)
    echo "$D3$description$C0"
    show_tree $1
}

chk_host(){
    if [ "$host_ip" ] ; then
        site="$network.$host_ip"
    else
        site="$self_host"
    fi
    echo -n '.'
    ping -c1 -w1 "$site" &>/dev/null
}

chk_mac(){
    [[ $(hostname) =~ $self_host ]] && return
    local mac=$(search-mac $self_host)
    [ "$mac" ] && [[ $mac =~ $exp ]]
}

# Options
opt-p(){ echo "Checking ";nl=$'\n';cmd="chk_host"; } # ping check
xopt-l(){ # check local net
    eval $(info-net)
    echo "NET=$cidr"
    exp="^($(sudo nmap -n -sn $cidr | grep MAC | cut -d ' ' -f 3 | tr '\n' '|'))$"
    cmd="chk_mac"
    local mynet=$(net-name)
    IFS='|'
    get_hubs $mynet
    get_hosts
    top_tree $mynet
}

### main ###
declare -A sub
declare -A super
declare -A title
declare -A fiber
declare -A connect
_usage "[subnet]" $(db-list subnet)
_exe_opt
IFS='|'
for i;do
    get_hubs $i
done
get_hosts
echo -n "$nl"
for i;do
    top_tree $i
done
