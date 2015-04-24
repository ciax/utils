#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.temp
opt-s(){ #Set to /etc/hosts
    _temp hosts
    egrep -v " $hosts$" /etc/hosts > $hosts
    echo "$line" >> $hosts
    _overwrite $hosts /etc/hosts
    echo "Set to /etc/hosts"
}
_usage "[host]"
host=$1;shift
set - $(search-mac $host)
mac=$1
if [ "$mac" ] ; then
    echo "Searching $host ($mac)"
    eval "$(info-net)"
    nmap -sn $cidr > /dev/null 2>&1
    set - $(arp -n|egrep -i "($mac)")
    line="$1    $host"
    if [ "$1" ] ; then 
        echo "Find $1"
        _exe_opt
    else
        echo "Can't find $host"
    fi
else
    echo "No such host $1"
fi

