#!/bin/bash
# Required commands: ip netstat
# Recommended app: ipcalc
shopt -s nullglob
while read h x t x i x; do
    if [ "$h" = default -a ! "$netif" ] ; then
        gw=$t
        netif=$i
    elif [ "$t" = "$netif" -a ! "$cidr" ] ; then
        cidr=$h
    fi
done < <(ip route)
set - $(ifconfig $netif | egrep '(inet |ether)')
echo "netif=$netif"
echo "hostip=$2"
echo "subnet=${cidr%/*}"
echo "netmask=$4"
echo "cidr=$cidr"
echo "bcast=$6"
echo "gw=$gw"
echo "mac=$8"
