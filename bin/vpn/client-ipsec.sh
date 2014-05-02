#!/bin/bash
#alias ivpn
# Required packages(Debian): vpnc
# Required scripts: func.getpar cfg-ipsec
# Description: vpn client of ipsec
. func.getpar
xopt-d(){ #disconnect
    sudo vpnc-disconnect && echo "IPsec VPN Terminated"
}

PATH+=:/usr/sbin
_usage "[vpnhost]" <(db-list vpn)
. func.temp
_temp cfgfile
cfg-ipsec $* > $cfgfile
sudo vpnc $cfgfile
cd ~/bin;ln -sf $0 vpn
