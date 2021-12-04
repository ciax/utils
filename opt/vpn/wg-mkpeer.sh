#!/bin/bash
#alias mkpeer
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: Make Own Peer File
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
opt-s(){ # Save to Config Dir
    echo "Printed out to cfg dir"
    prpeer > ~/cfg.def/etc/wg0.$HOSTNAME.peer
}
# Shared Procedures
mkkeys(){
    [ "$1" ] || { echo "No prv file setting"; return; }
    privkey=$1
    if [ ! -e $privkey ]; then
	wg genkey > $privkey
	chmod 600 $privkey
	echo "$privkey was generated"
    fi
    pubkey=$(wg pubkey < $privkey)
}
getnet(){
    eval $(info-net)
    IFS=.
    set - $subnet
    IFS=
    tunaddr="10.0.$3.254"
    [ "$ipv6" ] && dstaddr="[$ipv6]" || dstaddr="$global"
}
# Printing SV Peers
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "EndPoint = $dstaddr:51820"
    echo "AllowedIPs = $tunaddr/32, $cidr"
}
# Making Working Directory
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage
# Making Config Files
mkkeys privkey
getnet
prpeer
_exe_opt
