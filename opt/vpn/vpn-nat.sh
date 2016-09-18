#!/bin/bash
#alias nat
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
    set - $(ifconfig|grep eth); out=$1
    src=172.16.0.0/16
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo iptables -t nat -A POSTROUTING -o $out -s $src -j MASQUERADE --modprobe=/sbin/modprobe
    echo "NAT setting done at $HOSTNAME($1)"
}
natstat(){
    sudo iptables -t nat -vL
}
_usage "[command]" $(_caselist)
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
