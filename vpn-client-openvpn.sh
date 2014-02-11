#!/bin/bash
# Client for dd-wrt openvpn server
. cfg-openvpn -i $1
ln -sf `realpath $0` ~/bin/vpn-client
ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
nat set # Need NAT setup (naoj can't look up 172 address)
sudo grep openvpn /var/log/syslog
