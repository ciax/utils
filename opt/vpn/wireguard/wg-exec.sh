#!/bin/bash
#alias wgs stat
#alias wgc conf
#alias wgu up
#alias wgd dw
# Required packages: wireguard
# Required scripts: func.getpar
# Description: execute wireguard
. func.getpar
#
setfw(){
    grep -q 1 /proc/sys/net/ipv4/ip_forward || sudo sysctl -w net.ipv4.ip_forward=1
}
_usage "[command]" $(_caselist)
case "$1" in
    up) #Link Up
	setfw
        sudo wg-quick up wg0;;
    dw) #Linc Down
        sudo wg-quick down wg0;;
    conf) #Show config
        sudo cat /etc/wireguard/wg0.conf;;
    stat) #Show status
        sudo wg show;;
    *);;
esac
