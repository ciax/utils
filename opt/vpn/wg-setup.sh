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
xopt-c(){ #Generate client QR code
    svpvkey=$privkey
    privkey=privkey.cli
    mkprv
    setnet
    prcliif
    prclipeer > ~/cfg.def/etc/$host.cli.peer
}
# Subroutines
prnat(){
    echo "iptables -$1 FORWARD -i wg0 -j ACCEPT; iptables -t nat -$1 POSTROUTING -o $netif -j MASQUERADE"
}
# Shared Procedures
mkprv(){
    mkdir -p -m 700 ~/.wg
    cd ~/.wg
    [ "$privkey" ] || { echo "No prv file setting"; return; }
    if [ ! -e $privkey ]; then
	wg genkey > $privkey
	chmod 600 $privkey
	echo "$privkey was generated"
    fi
    pubkey=$(wg pubkey < $privkey)
}
setnet(){
    eval $(info-net)
    IFS=.
    set - $subnet
    IFS=
    myaddr="10.0.0.1$3"
    host=$(hostname)
}
# Printing Interface Part
prcliif(){
    echo "[Interface]"
    echo "PrivateKey = $(< $privkey)"
    echo "Address = 10.0.0.100/24"
    echo "DNS = 8.8.8.8"
}
prsrvif(){
    echo "[Interface]"
    echo "PrivateKey = $(< $privkey)"
    echo "Address = $myaddr/24"
    echo "ListenPort = 51820"
    echo "PostUp = $(prnat A)"
    echo "PostDown = $(prnat D)"
}
# Printing Peer Part
prclipeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = 0.0.0.0/0"
    echo "EndPoint = [$ipv6]:51820"
}
prsrvpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $myaddr/32, $cidr"
    echo "EndPoint = [$ipv6]:51820"
}
setpeer(){
    peer=$1.peer
    prsrvpeer > ~/cfg.def/etc/$peer
    ln -sf ~/cfg.*/etc/*.peer .
    rm $peer
}
prsvcfg(){
    echo "#file /etc/wireguard/wg0.conf"
    prsrvif
    echo
    [ "$(echo *.peer)" ] && cat *.peer
}
_usage
privkey=privkey
mkprv
setnet
setpeer $host
prsvcfg
