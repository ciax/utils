#!/bin/bash
# Client for dd-wrt openvpn server
[ "$1" ] || . set.usage "[remote host]"
remote=$1
vardir=$HOME/.var
host=`hostname`
cfgfile=~/.var/openvpn-$remote.conf
net=$(echo "select network,netmask from route where vpn = '$remote';"|db-device|tr ',' ' ')
[ "$net" ] || { echo "No such host in DB"; exit; }
cat > $cfgfile <<EOF
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
remote $remote 1194
resolv-retry infinite
nobind
#persist-key
#persist-tun
ns-cert-type server
route $net
status /var/log/openvpn-status.log
EOF
