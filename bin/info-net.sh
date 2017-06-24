#!/bin/bash
# Required commands: ip netstat
# Recommended app: ipcalc
shopt -s nullglob
set - $(ip route|sort -r)
gw=$3
cidr=$6
netif=$8
set - $(ifconfig $netif | egrep '(inet |ether)')
echo "netif=$netif"
echo "hostip=$2"
echo "subnet=${cidr%/*}"
echo "netmask=$4"
echo "cidr=$cidr"
echo "bcast=$6"
echo "gw=$gw"
echo "mac=$8"
