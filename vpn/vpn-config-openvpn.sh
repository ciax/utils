#!/bin/bash
# Client for dd-wrt openvpn server
[ "$1" ] || . set.usage "[remote host] (outputfile)"
remote=$1
vardir=$HOME/.var
host=`hostname`
server=$(echo "select host from vpn where id = '$remote';"|db-register)
[ "$server" ] || { echo "No such host in DB"; exit; }
out=${2:-/dev/stdout}
cat > $out <<EOF
verb 3
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
status $vardir/openvpn-status.log
ns-cert-type server
EOF
vpn-route $remote|cut -d' ' -f1,4,6 >> $out
## Server Setting on DD-WRT v24-sp2
# OpenVPN: Enable
# Start Type: WAN Up
# Config as: Server
# Server mode: Router(TUN)
# Network: 10.0.0.0
# Netmask: 255.255.255.0
# Port: 1194
# Tunnel Protocol: UDP
# Encryption Cipher: Blowfish CBC
# Hash Algorithm: SHA1
# Advanced Options: Disable
# Public Server Cert: --BEGIN CERTIFICATE --
# CA Cert: -- BEGIN CERTIFICATE --
# DH PEM: -- BEGIN DH PARAMETERS --
# Additional Config: blank
# TLS Auth Key: blank
# Certificate Revoke List: blank

