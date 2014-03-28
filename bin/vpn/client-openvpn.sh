#!/bin/bash
#alias ovpn
# Required packages: openvpn
# Required scripts: rc.app, db-list, cfg-openvpn, vpn-nat, show-syslog
# Description: client for dd-wrt openvpn server
. rc.app
# Options
opt-d(){ sudo kill $(< ~/.var/openvpn.pid) && echo "Openvpn Terminated";exit; }
_chkarg $(db-list vpn)
set - "$ARGV"
_usage "(-d:disconnect) [vpnhost]" $1
_temp cfgfile
. cfg-openvpn $1 > $cfgfile
sudo ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
