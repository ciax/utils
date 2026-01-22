#!/bin/bash
# Required packages: nmap
# Required scripts: func.getpar func.file db-exec
# Required tables: host hub subnet
# Description: show network tree
. func.getpar

# Highlight upper hub connection when at least one host alive
open_super(){
    connect[$1]=true
    local up="${super[$1]}"
    [ "$up" ] && [ ! "${connect[$up]}" ] && open_super "$up"
}

get_hubs(){
    while read self_hub sup po desc; do
        [ "$self_hub" ] || continue
        sup="${sup:-$1}"
        sub[$sup]+="|$self_hub" # add itself to parent var
        super[$self_hub]="$sup"
        port[$self_hub]="$po"
        title[$self_hub]="$desc"
        eval $(db-trace $self_hub hub subnet)
    done < <(db-exec "select id,super,port,description from hub where subnet == '$1';"|sort)
    network=${network%.0}
}

get_hosts(){
    for sup in ${!title[*]};do
        while read self_host host_ip; do
            sub[$sup]+="|$self_host:"
            super[$self_host:]="$sup"
            title[$self_host:]="$self_host"
            ${cmd:-true} && open_super $self_host:
        done < <(db-exec "select host from mac where hub == '$sup';")
    done
    [ "$cmd" ] && echo # return after progress dot
}

show_tree(){
    [ "$1" ] || return
    [ "${#2}" -gt  100 ] && _abort "Infinite Loop Error"
    last="${sub[$1]##*|}"
    local p ind="$2   "
    for i in ${sub[$1]#*|};do
        [ "$i" ] || continue
        echo -n "${ind}|"
        p="${port[$i]}"
        case "$p" in
            opt)
                c='='
                echo -n $C3
            ;;
            e*)
                echo -n "${p#e}"
            ;;
            *)
                c='-'
            ;;
        esac
        if [ "${connect[$i]}" ] ; then
            echo -n "$c$c$c"
            [[ $i == *: ]] && echo -n $C4 || echo -n $C2
        else
            echo -n "$c${D1}X$c"
        fi
        echo "${title[$i]}"$C0
        # Recursive call
        [ "$i" = "$last" ] && sep=" " || sep="|"
        show_tree $i "$ind$sep "
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
    echo -n '.'
    local mac=$(search-mac $self_host)
    [ "$mac" ] || return
    [[ $mac =~ ^($exp)$ ]] || return
    exp=${exp/$mac/}
}

show_rest(){
    for i in $exp; do
        [ "$i" ] || continue
        echo -n '   |-'$C4
        arp | grep -i $i| cut -d' ' -f 1
        echo -n $C0
    done
}

# Options
opt-p(){ echo "Checking ";cmd="chk_host"; } #ping check
xopt-l(){ #check local net
    eval $(info-net)
    echo "NET=$subnet"
    echo "Checking "
    exp="$(sudo nmap -n -sn $subnet | grep MAC | cut -d ' ' -f 3 | tr '\n' '|')"
    cmd="chk_mac"
    local mynet=$(net-name)
    IFS='|'
    get_hubs $mynet
    get_hosts
    top_tree $mynet
    show_rest
}

### main ###
declare -A sub
declare -A super
declare -A title
declare -A port
declare -A connect
_usage "[subnet]" $(db-list subnet)
_exe_opt
IFS='|'
for i;do
    get_hubs $i
done
get_hosts
for i;do
    top_tree $i
done
