#!/bin/bash
# Required commands: iptables,ifconfig,sysctl
# Required scripts: func.getpar
# Description: setting nat table
. func.getpar
#
clrtbl(){
# Filtering Clear Tables
    sudo iptables -F
    sudo iptables -X
    sudo iptables -Z
# Filtering All Accepted
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
# Nat setting
    sudo iptables -t nat -F
    echo "IP table cleared"
}
setnat(){
    set - `ifconfig eth`
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE --modprobe=/sbin/modprobe
    echo "NAT setting done at $HOSTNAME($1)"
}
natstat(){
    sudo iptables -t nat -L
}
_usage "[command]" <(_caselist)
case "$1" in
    clr) #Clear the table
        clrtbl;;
    set) #Set nat table
        clrtbl
        setnat;;
    stat) #Show status
        natstat;;
    *);;
esac
