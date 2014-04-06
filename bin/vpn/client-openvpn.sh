#!/bin/bash
#alias ovpn
# Required commands: sudo,openvpn,kill
# Required scripts: func.app, db-list, cfg-openvpn, vpn-nat, show-syslog
# Description: client for dd-wrt openvpn server
. func.app
# Options
opt-d(){ #disconnect
    sudo kill $(< ~/.var/openvpn.pid) && echo "Openvpn Terminated"
    exit
}
_usage "[vpnhost]" $(db-list vpn)
_selflink vpn
_temp cfgfile
. cfg-openvpn $1 > $cfgfile
sudo ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
