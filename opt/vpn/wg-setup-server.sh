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
# Printing Common Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< privkey)"
    echo "Address = $wg_tun/16"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    echo "ListenPort = 51820"
}
prpeers(){
    for i in wg_peer.*.txt; do
	. $i
	echo "[Peer]"
	echo "PublicKey = $wg_pub"
	echo "AllowedIPs = $wg_tun/32, $wg_sub"
    done
}
# Making Config Files
prcl(){
    [ -d client ] || return
    cd client
    [ "$(echo wg0.*.peer)" ] &&  { cat wg0.*.peer| grep -v EndPoint; }
}
prcfg(){
    ln -sf ~/cfg.*/etc/wg_peer.*.txt .
    . wg_peer.$HOSTNAME.txt
    rm wg_peer.$HOSTNAME.txt
    echo "#file /etc/wireguard/wg0.conf"
    prif
    prpeers
    prcl
}
# Main
mkdir -p ~/.var/wg/client
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage
prcfg
_exe_opt
