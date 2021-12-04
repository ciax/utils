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
_usage
opt-s(){
    echo "Printed out to cfg dir"
    prpeer > ~/cfg.def/etc/wg0.$hostname.peer
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
    id=$1
    eval $(info-net)
    IFS=.
    set - $subnet
    IFS=
    tunaddr="10.0.$3.$id"
}
# Printing SV Peers
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $tunaddr/32, $cidr"
    echo "EndPoint = $address:51820"
}
# Making Working Directory
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
# Making Config Files
mkkeys privkey
getnet 254
[ "$ipv6" ] && address="[$ipv6]" || address="$global"
prpeer
_exe_opt
