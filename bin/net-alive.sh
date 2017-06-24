#!/bin/bash
# Required packages: nmap
# Required scripts: func.getpar db-exec db-trace db-list
# Required tables: mac host subnet
# Description: show alive devices
. func.getpar
opt-a(){ all=1; } # Show all hosts
chk_host(){
    if [ "$host_ip" ] ; then
        site="$network.$host_ip"
    elif read site a < <(getent hosts $id) ; then
        :
    else
        return
    fi
    if ping -c1 -w1 "$site" &>/dev/null; then
        echo "$network.$host_ip $id"
        res="${C2}o"
    else
        res="${C1}x"
    fi
    [ "$all" ] && _msg "$network.$host_ip\t$id\t-> $res"
}

# Options
xopt-l(){ # check local net
    eval $(info-net)
    echo "${mac^^} $HOSTNAME"
    while read mac; do
        unset device if host description
        eval $(db-trace $mac mac)
        if [ "$host" ] ; then
            echo "$mac $host"
        else
            echo "$mac ($device)"
        fi
    done < <(sudo nmap -n -sn $cidr | grep MAC | cut -d ' ' -f 3)
}

### main ###
_usage "[subnet]" $(db-list subnet)
_exe_opt
eval $(db-trace $1 subnet)
IFS='|'
while read id host_ip; do
    chk_host
done < <(db-exec "select id,host_ip from host where subnet == '$1';")
