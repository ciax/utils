#!/bin/bash
#alias mkcl
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: Making Client Peer Config
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
# Options
opt-s(){ # Write to /etc
    prcfg ${ARGV[1]}| text-update
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
}
# Making Config Files
prcfg(){
    dst=wg0.$1.peer
    ln -sf ~/cfg.*/etc/wg0.*.peer .
    rm wg0.$HOSTNAME.peer
    echo "#file /etc/wireguard/wg0.conf"
    getnet
    prif
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    grep -v AllowedIPs $dst
    allow="$(grep AllowedIPs $dst)"; rm $dst
    while read a ; do
	allow="$allow, $a"
    done < <(cat wg0.*.peer | grep AllowedIPs| cut -d, -f2)
    echo $allow
}
# Main
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage "[server]"
prcfg $1
_exe_opt
