#!/bin/bash
#alias mkwg
# Required packages: wireguard
# Required scripts: func.getpar
# Description: setting nat table
#
. func.getpar
mkprv(){
    mkdir -p -m 700 ~/.wg
    cd ~/.wg
    if [ ! -e privkey ] ; then
	wg genkey > privkey
	chmod 600 privkey
	echo "privkey was generated"
    fi
}
setvar(){
    eval $(info-net)
    myaddr=$(myaddr)
    pubkey=$(wg pubkey < privkey)
    host=$(hostname)
}
prif(){
    echo "[Interface]"
    echo "ListenPort = 51820"
    echo "PrivateKey = $(< privkey)"
    echo "Address = $myaddr/24"
    echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $netif -j MASQUERADE"
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $netif -j MASQUERADE"
}
prpeer(){
    echo "[Peer]"
    echo "PublicKey = $pubkey"
    echo "AllowedIPs = $myaddr/32, $cidr"
    echo "EndPoint = [$ipv6]:51820"
}
myaddr(){
    IFS=.
    set - $subnet
    echo "10.0.0.1$3"
}
getpeer(){
    peer=$host.peer
    touch ~/cfg.def/etc/$peer
    ln -sf ~/cfg.*/etc/*.peer .
    prpeer > $peer
    rm $peer
}

setfw(){
    sudo sysctl -w net.ipv4.ip_forward=1
}
prcfg(){
    prif
    echo
    [ "$(echo *.peer)" ] && cat *.peer
}

mkprv
setvar
getpeer
prcfg
