#!/bin/bash
#alias ivpn
# Required packages(Debian): vpnc
# Required scripts: func.temp cfg-ipsec
# Description: vpn client of ipsec
. func.temp
xopt-d(){ #disconnect
    sudo vpnc-disconnect && echo "IPsec VPN Terminated"
}

PATH+=:/usr/sbin
_usage "[vpnhost]" <(db-list vpn)
_temp cfgfile
cfg-ipsec $* > $cfgfile
sudo vpnc $cfgfile && ln -sf $(readlink $0) ~/bin/vpn
