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
xopt-s(){ # Write to /etc
    prcfg | text-update
}
# Subroutines
prnat(){
    echo "iptables -$1 FORWARD -i wg0 -j ACCEPT; iptables -t nat -$1 POSTROUTING -o $wg_if -j MASQUERADE"
}
# Printing Common Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< privkey)"
    echo "Address = $wg_tun/16"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    echo "ListenPort = 51820"
}
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $wg_pub"
    echo "AllowedIPs = $wg_tun/32, $wg_sub"
}

listpeers(){
    for i in wg_peer.*.txt; do
	. $i
	prpeer
    done
}
# Making Config Files
listcl(){
    [ -d client ] || return
    cd client
    [ "$(echo wg0.*.peer)" ] &&  { cat wg0.*.peer| grep -v EndPoint; }
}
prcfg(){
    ln -sf ~/cfg.*/etc/wg_peer.$HOSTNAME.txt .
    . wg_peer.$HOSTNAME.txt
    rm wg_peer.$HOSTNAME.txt
    echo "#file /etc/wireguard/wg0.conf"
    prif
    listpeers
    listcl
}
# Main
mkdir -p -m 700 ~/.wg
mkdir -p ~/.wg/client
cd ~/.wg
_usage
prcfg
