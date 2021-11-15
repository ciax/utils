#!/bin/bash
#alias mkwg
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: setting nat table
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
# Options
xopt-p(){ #Print Server Config
    mkv6cfg
    prv6cfg
}
xopt-c(){ #Print Client Config
    num=${1:-1}
    mkclcfg $num
    prclcfg
}
xopt-s(){ #Write to /etc/wireguard/wg0.conf"
    xopt-p | text-update
}
xopt-q(){ #Write Client QR code to http://localhost/wg/wg?.png
    num=${1:-1}
    xopt-c $num | qrencode -o ~/.var/wg/wg$num.png
}
# Subroutines
prnat(){
    echo "iptables -$1 FORWARD -i wg0 -j ACCEPT; iptables -t nat -$1 POSTROUTING -o $netif -j MASQUERADE"
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
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
}
# Printing CL/SV Peers
prclpeer(){
    prpeer
    echo "AllowedIPs = $tunaddr/32"
}
prsvpeer(){
    prpeer
    echo "AllowedIPs = 0.0.0.0/0"
    echo "EndPoint = $global:51820"
}
prv6peer(){
    prpeer
    echo "AllowedIPs = $tunaddr/32, $cidr"
    echo "EndPoint = [$ipv6]:51820"
}
# Making Config Files
mkclcfg(){ #Generate client
    mkkeys privkey$num.cli
    getnet $num
    prclpeer > wg0.client$num.peer
}
mkv6cfg(){
    mkkeys privkey
    getnet 254
    prv6peer > ~/cfg.def/etc/wg0.$hostname.peer
    prsvpeer > server.peer
}
# Printing Config Files
prv6cfg(){
    ln -sf ~/cfg.*/etc/wg0.*.peer .
    rm wg0.$hostname.peer
    echo "#file /etc/wireguard/wg0.conf"
    prif
    echo "ListenPort = 51820"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    [ "$(echo wg0.*.peer)" ] && cat wg0.*.peer
}
prclcfg(){
    prif
    echo "DNS = 8.8.8.8"
    cat server.peer
}
# Main
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage "[opt] (c,q=client num)"
