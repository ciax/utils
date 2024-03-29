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
    prcfg | qrencode -t UTF8
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
    tunaddr="${wg_tun%.*}.$num"
    prpeer > wg0.client$num.peer
}
# Printing Config Files
prcfg(){
    prif
    echo "DNS = 8.8.8.8"
    echo "[Peer]"
    echo "PublicKey = $wg_pub"
    echo "EndPoint = $wg_ipv4:51820"
    echo "AllowedIPs = 0.0.0.0/0"
}
# Main
mkdir -p -m 700 ~/.wg
mkdir -p ~/.wg/client
cd ~/.wg/client
_usage - "[client#(1-253)]" {1..253}
num=${1:-1}
. ~/etc/wg_peer.$HOSTNAME.txt
mkcfg $num
prcfg
_exe_opt
