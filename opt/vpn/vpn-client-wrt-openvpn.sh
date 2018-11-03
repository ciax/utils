#!/bin/bash
#alias ovpn
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar db-list vpn-client-cfg-openvpn vpn-nat sys-logview
# Description: client for dd-wrt openvpn server
. func.getpar
# Options
opt-d(){ #disconnect
    pidfile=~/.var/openvpn.pid
    [ -s $pidfile ] && sudo kill $(< $pidfile) && echo "Openvpn Terminated"
    exit
}
_usage "[vpnhost]" $(db-list vpn)
_exe_opt
_temp cfgfile
. vpn-client-cfg-openvpn $1 > $cfgfile
sudo ifconfig tun || { sudo openvpn --mktun --dev tun0;sleep 5; }
sudo openvpn --config $cfgfile
vpn-nat set # Need NAT setup (naoj can't look up 172 address)
sys-logview openvpn
ln -sf $(readlink $0) ~/bin/vpn
