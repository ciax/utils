#!/bin/bash
#alias vpno
# Required packages: openvpn
# Required scripts: rc.app, db-list, cfg-openvpn, vpn-nat, show-syslog
# Description: client for dd-wrt openvpn server
. rc.app
[ "$1" = "-d" ] && { sudo kill $(< ~/.var/openvpn.pid); exit; }
_usage "(-d:disconnect) [vpnhost]" $1 < <(db-list vpn)
cfgfile=~/.var/openvpn-$1.cfg
. cfg-openvpn $1 $cfgfile
ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
