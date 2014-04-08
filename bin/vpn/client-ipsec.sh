#!/bin/bash
#alias ivpn
# Required packages: vpnc
# Required scripts: func.getpar,cfg-ipsec
# Description: vpn client of ipsec
. func.getpar
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; } #disconnect
_usage "[vpnhost]" <(db-list vpn)
. func.temp
_temp cfgfile
cfg-ipsec $* > $cfgfile
sudo vpnc $cfgfile
cd ~/bin;ln -sf $0 vpn
