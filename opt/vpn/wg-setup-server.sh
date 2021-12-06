#!/bin/bash
#alias mksv
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: Making server config
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
# Options
opt-s(){ # Write to /etc
    prcfg | text-update
}
# Subroutines
prnat(){
    echo "iptables -$1 FORWARD -i wg0 -j ACCEPT; iptables -t nat -$1 POSTROUTING -o $netif -j MASQUERADE"
}
# Shared Procedures
getnet(){
    eval $(info-net)
    IFS=.
    set - $subnet
    IFS=
    tunaddr="10.0.$3.254"
}
# Printing Common Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< privkey)"
    echo "Address = $tunaddr/16"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    echo "ListenPort = 51820"
}
# Making Config Files
prpeers(){
    [ "$(echo wg0.*.peer)" ] && { cat wg0.*.peer| grep -v EndPoint; }
}
prcfg(){
    ln -sf ~/cfg.*/etc/wg0.*.peer .
    rm wg0.$HOSTNAME.peer
    echo "#file /etc/wireguard/wg0.conf"
    getnet
    prif
    prpeers
    cd client
    prpeers
}
# Main
mkdir -p ~/.var/wg/client
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage
prcfg
_exe_opt
