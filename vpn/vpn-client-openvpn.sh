#!/bin/bash
# Client for dd-wrt openvpn server
#alias ovpn
cfgfile=~/.var/openvpn-$1.cfg
. cfg-openvpn $1 $cfgfile
ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
