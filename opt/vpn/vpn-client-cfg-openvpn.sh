#!/bin/bash
# Required scripts: func.getpar db-list db-trace route-openvpn
# Description: client for dd-wrt openvpn server
# Required SSL files for Client:
# rootca.crt (Root Certificate)
# (host).crt (Client Certificate)
# (host).key (Client Secret Key)
. func.getpar
_usage "[vpnhost]" $(db-list vpn)
vardir=$HOME/.var
ssldir=$vardir/ssl
myhost=`hostname`
eval "$(db-trace $1 vpn ddns)"
dst="${fdqn:-$ip}"
[ "$dst" ] || _abort "No such host in DB"
cat <<EOF
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
remote $dst 1194
ca $ssldir/rootca.crt
cert $ssldir/$myhost.crt
key $ssldir/$myhost.key
writepid $vardir/openvpn.pid
status $vardir/openvpn-status.log
ns-cert-type server
tun-mtu 1400
EOF
route-openvpn $1
# Required SSL files for Server:
# rootca.crt (Root Certificate)
# server.crt (Server Certificate)
# dh.pem (DH pem file)

### Server Setting on DD-WRT v24-sp2

## [Services]/[VPN]/<OpenVPN Server/Daemon>
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
# Public Server Cert: --BEGIN CERTIFICATE -- (server.crt)
# CA Cert: -- BEGIN CERTIFICATE -- (rootca.crt)
# DH PEM: -- BEGIN DH PARAMETERS -- (dh.pem)
# Additional Config: route x.x.x.x y.y.y.y (routing to client)
# TLS Auth Key: blank
# Certificate Revoke List: blank

## [Administraton]/[Commands]/<Diagnostics> (Execute at Startup)
# echo "iroute x.x.x.x 255.255.255.0" > /tmp/openvpn/ccd/$site
