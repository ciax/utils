#!/bin/bash
#alias vpni
# Required packages: vpnc
# Required scripts: rc.app
# Description: vpn client of ipsec
. rc.app
_usage "(-d:disconnect) [vpnhost]" $1 < <(db-list vpn)
_temp config
cfg-ipsec $* > $config
PATH=$PATH:/usr/sbin
sudo vpnc-disconnect
[ "$1" = -d ] && exit
sudo vpnc $config

