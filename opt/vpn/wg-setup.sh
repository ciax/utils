#!/bin/bash
#alias mkwg
# Required packages: wireguard qrencode
# Required scripts: func.getpar
# Description: setting nat table
#
. func.getpar
# Options
xopt-s(){ #Write to /etc/wireguard/wg0.conf"
    $0 | text-update
    sudo sysctl -w net.ipv4.ip_forward=1
}
xopt-c(){ #Generate client
    mkclcfg $*
    prclcfg
}
xopt-q(){ #Generate client QR code
    xopt-c $* | qrencode -t ansiutf8
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
    eval $(info-net)
}
tunnet(){
    IFS=.
    set - $subnet
    IFS=
    tunaddr="10.0.0.1$3"
}
# Printing Common Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< $privkey)"
    echo "Address = $tunaddr/24"
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
    num=${1:-0}
    mkkeys privkey$num.cli
    tunaddr=10.0.1.1$num
    prclpeer > wg0.client$num.peer
}
mkv6cfg(){
    mkkeys privkey
    tunnet
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
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage "(c=client num)"
mkv6cfg
prv6cfg
