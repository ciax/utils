#!/bin/bash
# Required packages: nmap
# Required scripts: func.getpar db-exec db-trace db-list
# Required tables: mac host subnet
# Description: show alive devices
. func.getpar

chk_host(){
    if [ "$host_ip" ] ; then
        site="$network.$host_ip"
    elif read site a < <(getent hosts $id) ; then
        :
    else
        return
    fi
    if ping -c1 -w1 "$site" &>/dev/null; then
        res="${C2}o"
    else
        res="${C1}x"
    fi
    _msg "$network.$host_ip\t$id\t-> $res"
}

# Options
xopt-l(){ # check local net
    eval $(info-net)
    while read mac; do
        unset device if host description
        eval $(db-trace $mac mac)
        if [ "$host" ] ; then
            _msg "$mac $host"
        else
            _msg "$mac ($device)"
        fi
    done < <(sudo nmap -n -sn $cidr | grep MAC | cut -d ' ' -f 3)
}

### main ###
_usage "[subnet]" $(db-list subnet)
eval $(db-trace $1 subnet)
IFS='|'
while read id host_ip; do
    chk_host
done < <(db-exec "select id,host_ip from host where subnet == '$1';")
