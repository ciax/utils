#!/bin/bash
#alias mktm
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: WireGuard Terminal Client Setting
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
# Options
opt-q(){ #Write Client QR code to http://localhost/wg/wg?.png
    prcfg | qrencode -o ~/.var/wg/wg$num.png
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
# Printing Common Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< $privkey)"
    echo "Address = $tunaddr/16"
}
# Printing CL/SV Peers
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $tunaddr/32"
}
# Making Config Files
mkcfg(){ #Generate client
    mkkeys privkey$num.cli
    getnet $num
    prpeer > wg0.client$num.peer
}
# Printing Config Files
prcfg(){
    prif
    echo "DNS = 8.8.8.8"
    grep -v AllowedIPs ~/cfg.def/etc/wg0.$hostname.peer
    echo "AllowedIPs = 0.0.0.0/0"
}
# Main
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage "[client number]"
num=${1:-1}
mkcfg $num
prcfg
_exe_opt
