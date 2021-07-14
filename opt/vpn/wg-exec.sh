#!/bin/bash
#alias xwg
# Required packages: wireguard
# Required scripts: func.getpar
# Description: execute wireguard
. func.getpar
#
_usage "[command]" $(_caselist)
case "$1" in
    up) #Link Up
        sudo wg-quick up wg0;;
    dw) #Linc Down
        sudo wg-quick down wg0;;
    stat) #Show status
        sudo wg show;;
    *);;
esac
