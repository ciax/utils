#!/bin/bash
# Description: client for dd-wrt openvpn server
# packages: openvpn
# Required scripts: func.usage, db-list, cfg-openvpn, vpn-nat, show-syslog
#alias vpno
[ "$1" = "-r" ] && { sudo kill $(< ~/.var/openvpn.pid); exit; }
. func.usage "(-r:remove) [vpnhost]" $1 < <(db-list vpn)
cfgfile=~/.var/openvpn-$1.cfg
. cfg-openvpn $1 $cfgfile
ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
