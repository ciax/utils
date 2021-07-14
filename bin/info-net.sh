#!/bin/bash
# Required commands: ip netstat
# Recommended app: ipcalc
shopt -s nullglob
while read h x t x i x
do
    if [ "$h" = default -a ! "$netif" ]
    then
        gw=$t
        netif=$i
    elif [ "$t" = "$netif" -a ! "$cidr" ]
    then
        cidr=$h
    fi
done < <(ip route)
eval $(ifconfig eth0|egrep -v 'link'|sed -e 's/  /\n/g'|egrep '^(i|n|br|ether)'|tr ' ' =)
echo "netif=$netif"
echo "hostip=$inet"
echo "subnet=${cidr%/*}"
echo "netmask=$netmask"
echo "cidr=$cidr"
echo "bcast=$broadcast"
echo "gw=$gw"
echo "mac=$ether"
echo "ipv6=$inet6"
echo "global=$(curl -s inet-ip.info)"
echo "hostname=$(hostname)"
