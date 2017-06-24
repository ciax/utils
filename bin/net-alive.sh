#!/bin/bash
# Required packages: nmap
# Required scripts: func.getpar func.temp db-exec
# Required tables: host hub subnet
# Description: show network tree
. func.getpar
. func.temp

chk_host(){
    if [ "$host_ip" ] ; then
        site="$network.$host_ip"
    elif read site a < <(getent hosts $id) ; then
        :
    else
        return
    fi
    #echo -n '.' 1>&2
    if ping -c1 -w1 "$site" &>/dev/null; then
        _msg "$network.$host_ip $id -> ${C2}o"
    else
        _msg "$network.$host_ip $id -> ${C1}x"
    fi
}

chk_mac(){
    search-mac $self $tempfile
    grep $(search-mac $self) $tempfile &>/dev/null
}

# Options
xopt-l(){ # check local net
    eval $(info-net)
    _temp tempfile
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
