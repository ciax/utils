#!/bin/bash
# Client for dd-wrt openvpn server
[ "$1" ] || . set.usage "[remote host] (outputfile)"
remote=$1
vardir=$HOME/.var
host=`hostname`
server=$(echo "select host from vpn where id = '$remote';"|db-device)
[ "$server" ] || { echo "No such host in DB"; exit; }
cat > ${2:-/dev/stdout} <<EOF
script-security 2
verb 3
comp-lzo
keepalive 15 60
management localhost 7505
proto udp
dev tun
daemon
ca $vardir/ca.crt
cert $vardir/$host.crt
key $vardir/$host.key
client
tls-client
remote $server 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ns-cert-type server
$(vpn-route $remote|cut -d' ' -f1,4,6)
status /var/log/openvpn-status.log
EOF
