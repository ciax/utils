#!/bin/bash
#alias ovpn
# Required packages(Debian): openvpn
# Required scripts: func.getpar func.temp db-list cfg-openvpn vpn-nat show-syslog
# Description: client for dd-wrt openvpn server
. func.getpar
# Options
xopt-d(){ #disconnect
    pidfile=~/.var/openvpn.pid
    [ -s $pidfile ] && sudo kill $(< $pidfile) && echo "Openvpn Terminated"
}
_usage "[vpnhost]" <(db-list vpn)
. func.temp
_temp cfgfile
. cfg-openvpn $1 > $cfgfile
sudo ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
show-syslog openvpn
ln -sf $(readlink $0) ~/bin/vpn
