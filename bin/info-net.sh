#!/bin/bash
# Required commands: ip netstat
# Recommended app: ipcalc
shopt -s nullglob
while read cidr x b x c x x s hostip x; do
    [ $b = "$netif" -a "$s" = "src" ] && break
    [ $cidr = 'default' ] && { gw=$b; netif=$c; }
done < <(ip route|sort -r)
read x x x bcast x < <(ip addr|grep $netif$)
read subnet x netmask x < <(netstat -nr|egrep -v ^0|grep $netif)
echo "netif=$netif"
echo "hostip=$hostip"
echo "subnet=$subnet"
echo "netmask=$netmask"
echo "cidr=$cidr"
echo "bcast=$bcast"
echo "gw=$gw"
