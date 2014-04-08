#!/bin/bash
#alias ivpn
# Required commands: sudo,vpnc
# Required scripts: func.getpar,cfg-ipsec
# Description: vpn client of ipsec
. func.getpar
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; } #disconnect
_usage "[vpnhost]" <(db-list vpn)
sudo vpnc <(cfg-ipsec $*)
cd ~/bin;ln -sf $0 vpn
