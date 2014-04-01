#!/bin/bash
# Required packages: coreutils
# Required scripts: src.app, db-list, db-trace, route-openvpn
# Description: client for dd-wrt openvpn server
# Required SSL files for Client:
# rootca.crt (Root Certificate)
# (host).crt (Client Certificate)
# (host).key (Client Secret Key)
. src.app
_chkarg $(db-list vpn)
_usage "[vpnhost]"
vardir=$HOME/.var
myhost=`hostname`
eval "$(db-trace $1 vpn host)"
[ "$fdqn" ] || _abort "No such host in DB"
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
remote $fdqn 1194
ca $vardir/rootca.crt
cert $vardir/$myhost.crt
key $vardir/$myhost.key
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
# Public Server Cert: --BEGIN CERTIFICATE -- (server.crt)
# CA Cert: -- BEGIN CERTIFICATE -- (rootca.crt)
# DH PEM: -- BEGIN DH PARAMETERS -- (dh.pem)
# Additional Config: blank
# TLS Auth Key: blank
# Certificate Revoke List: blank

