#!/bin/bash
#alias mkwg
# Required packages: wireguard
# Required scripts: func.getpar
# Description: setting nat table
#
. func.getpar
mkprv(){
    if [ ! -e $prvkey ] ; then
	wg genkey # > $prvkey
	#    chmod 600 $prvkey
	echo "prvkey was generated"
    fi
}
mkif(){
    echo "[Interface]"
    echo "ListenPort = 51820"
    echo "PrivateKey = $(< $prvkey)"
    echo "Address = $myaddr/24"
    echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $netif -j MASQUERADE"
    echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $netif -j MASQUERADE"
}
mkpeer(){
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
setvar(){
    eval $(info-net)
    myaddr=$(myaddr)
    pubkey=$(wg pubkey < $prvkey)
    host=$(hostname)
}

setfw(){
    sudo sysctl -w net.ipv4.ip_forward=1
}
prvkey=~/.ssh/privkey
mkprv
setvar
mkpeer > $host.peer
mkif
echo
for i in *.peer; do
    [ $i = $host.peer ] && continue
    cat $i
done
