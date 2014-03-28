#!/bin/bash
#alias ivpn
# Required packages: vpnc
# Required scripts: rc.app
# Description: vpn client of ipsec
. rc.app
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; }
_chkarg $(db-list vpn)
_usage "(-d:disconnect) [vpnhost]"
set - $ARGV
_temp config
cfg-ipsec $* > $config
sudo vpnc $config

