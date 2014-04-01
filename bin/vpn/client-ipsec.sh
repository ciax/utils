#!/bin/bash
#alias ivpn
# Required packages: vpnc
# Required scripts: func.app
# Description: vpn client of ipsec
. func.app
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; }
_chkarg $(db-list vpn)
_usage "(-d:disconnect) [vpnhost]"
_temp config
cfg-ipsec $* > $config
sudo vpnc $config

