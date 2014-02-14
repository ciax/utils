#!/bin/bash
# Client for dd-wrt openvpn server
[ "$1" ] || . set.usage "[remote host] (outputfile)"
remote=$1
vardir=$HOME/.var
host=`hostname`
server=$(echo "select host from vpn where id = '$remote';"|db-device)
[ "$server" ] || { echo "No such host in DB"; exit; }
cat > ${2:-/dev/stdout} <<EOF
#verb 3
script-security 2
client
comp-lzo
dev tun
proto udp
resolv-retry infinite
nobind
persist-key
persist-tun
float
daemon
keepalive 15 60
ca $vardir/rootca.crt
cert $vardir/$host.crt
key $vardir/$host.key
remote $server 1194
$(vpn-route $remote|cut -d' ' -f1,4,6)
status $vardir/openvpn-status.log
auth MD5
ns-cert-type server
EOF
