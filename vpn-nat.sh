#!/bin/bash
. ~/lib/libapp.sh
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
    echo IP table cleared
}

###CLR###

setnat(){
    set - `ifconfig eth`
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE --modprobe=/sbin/modprobe
    echo "NAT setting done at $HOSTNAME($1)"
}

###SET###

natstat(){
    sudo iptables -t nat -L
}

###STAT###
case "$1" in
    clr)
        clrtbl;;
    set)
        clrtbl
        setnat;;
    stat)
        natstat;;
    *)
        . set.usage "[clr|set|stat]"
        ;;
esac
