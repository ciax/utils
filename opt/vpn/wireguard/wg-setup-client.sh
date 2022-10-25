#!/bin/bash
#alias mkcl
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: Making Client Peer Config
#
# Tunnel IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
# Options
xopt-s(){ # Write to /etc
    prcfg $servers| text-update
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
    echo -n "ListenPort = 51820"
}
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $wg_pub"
    echo "EndPoint = $wg_ipv4:51820"
    echo -n "AllowedIPs = $wg_tun/32, $wg_sub"
}
setpar(){
    local file=wg_peer.$1.txt
    [ -e $file ] || return
    . $file
    rm $file
}
# Making Config Files
listpeers(){
    for i ;do
	echo
	setpar $i && prpeer
    done
    for i in wg_peer.*.txt; do
	. $i
	echo -n ", $wg_sub"
    done
    echo
} 
listcl(){
    [ -d client ] || return
    cd client
    [ "$(echo wg0.*.peer)" ] &&  { cat wg0.*.peer| grep -v EndPoint; }
}
prcfg(){
    # sorting
    ln -sf ~/cfg.*/etc/wg_peer.*.txt .
    setpar $HOSTNAME
    # printing
    echo "#file /etc/wireguard/wg0.conf"
    prif
    listpeers $*
    listcl
}
# Main
mkdir -p -m 700 ~/.wg
mkdir -p ~/.wg/client
cd ~/.wg
servers="$*"
list_peer="$(ls ~/cfg.*/etc/wg0.*.peer|grep -v $HOSTNAME|cut -d. -f3|sort -u)"
_usage "[servers]" $list_peer
prcfg $servers
