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
xopt-s(){ # Write to /etc
    prcfg $servers| text-update
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
}
# Making Config Files
prcfg(){
    # sorting
    ln -sf ~/cfg.*/etc/wg0.*.peer .
    rm wg0.$HOSTNAME.peer
    # printing
    echo "#file /etc/wireguard/wg0.conf"
    getnet
    prif
    for i ;do
	file=wg0.$i.peer
	[ -e $file ] || continue
	cat $file; rm $file
    done | head -c -1
    if [ wg0.*.peer ]; then
	allow=$(grep AllowedIPs wg0.*.peer | cut -d, -f2 | tr $'\n' , )
	echo ",${allow%,}"
    else
	echo
    fi
} 
# Main
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
servers="$*"
list_peer="$(ls ~/cfg.*/etc/wg0.*.peer|grep -v $HOSTNAME|cut -d. -f3|sort -u)"
_usage "[servers]" $list_peer
prcfg $servers
