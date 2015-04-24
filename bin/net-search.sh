#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.temp
opt-s(){ #Set to /etc/hosts
    egrep -v " ($reg)$" /etc/hosts > $hosts
    cat $hlist >> $hosts
    _overwrite $hosts /etc/hosts
    echo "Set to /etc/hosts"
}
_usage "[host].."
declare -A macs
for host ; do
    mac=$(search-mac $host)
    if [ "$mac" ] ; then
        macs[$host]=$mac
        reg="$reg${reg:+|}$host"
    else
        echo "No such host $host"
    fi
done
[ "$reg" ] || exit 1

_temp mlist hlist hosts
eval "$(info-net)"
echo "Scannig network ($cidr)"
nmap -sn $cidr > /dev/null 2>&1
arp -n|grep -v incomplete > $mlist
for host in ${!macs[*]} ; do
    mac=${macs[$host]}
    set - $(egrep -i "($mac)" $mlist)
    ip=$1
    if [ "$ip" ] ; then 
        echo "Find $ip for $host ($mac)"
        echo "$ip    $host" >> $hlist 
    else
        echo "Can't find $host"
    fi
done
_exe_opt


