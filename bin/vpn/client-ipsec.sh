#!/bin/bash
#alias ivpn
# Required packages: vpnc
# Required scripts: src.app
# Description: vpn client of ipsec
. src.app
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; }
_chkarg $(db-list vpn)
_usage "(-d:disconnect) [vpnhost]"
_temp config
cfg-ipsec $* > $config
sudo vpnc $config

