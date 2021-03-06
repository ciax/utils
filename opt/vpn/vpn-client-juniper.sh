#!/bin/bash
#alias ivpn
# Required packages(Debian,Raspbian): vpnc
# Required scripts: func.getpar vpn-client-cfg-ipsec
# Description: vpn client of ipsec
. func.getpar
xopt-d(){ #disconnect
    sudo vpnc-disconnect && echo "IPsec VPN Terminated"
    exit
}

PATH+=:/usr/sbin
_usage "[vpnhost]" $(db-list vpn)
_exe_opt
_temp cfgfile
vpn-client-cfg-ipsec $* > $cfgfile
sudo vpnc $cfgfile && ln -sf $(readlink $0) ~/bin/vpn
