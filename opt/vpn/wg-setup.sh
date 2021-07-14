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
    mkprv privkey.cli
    myaddr=10.0.0.100
    prclpeer > ~/cfg.def/etc/client.peer
    prclcfg
}
xopt-q(){ #Generate client QR code
    xopt-c | qrencode -t ansiutf8
}
server(){
    mkprv privkey
    tunnet
    prsvpeer > ~/cfg.def/etc/$host.peer
    prsvcfg
}

# Subroutines
prnat(){
    echo "iptables -$1 FORWARD -i wg0 -j ACCEPT; iptables -t nat -$1 POSTROUTING -o $netif -j MASQUERADE"
}
# Shared Procedures
mkprv(){
    [ "$1" ] || { echo "No prv file setting"; return; }
    privkey=$1
    if [ ! -e $privkey ]; then
	wg genkey > $privkey
	chmod 600 $privkey
	echo "$privkey was generated"
    fi
    pubkey=$(wg pubkey < $privkey)
    host=$(hostname)
}
tunnet(){
    eval $(info-net)
    IFS=.
    set - $subnet
    IFS=
    myaddr="10.0.0.1$3"
}
# Printing Interface Part
prif(){
    echo "[Interface]"
    echo "PrivateKey = $(< $privkey)"
    echo "Address = $myaddr/24"
}
# Printing Peer Part
prclpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $myaddr/32"
}
prsvpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $myaddr/32, $cidr"
    echo "EndPoint = [$ipv6]:51820"
}
prsvcfg(){
    ln -sf ~/cfg.*/etc/*.peer .
    rm $host.peer
    echo "#file /etc/wireguard/wg0.conf"
    prif
    echo "ListenPort = 51820"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
    [ "$(echo *.peer)" ] && cat *.peer
}
prclcfg(){
    prif
    echo "DNS = 8.8.8.8"
    cat ~/cfg.def/etc/$host.peer
}
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage
server
