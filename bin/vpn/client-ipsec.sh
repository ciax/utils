#!/bin/bash
#alias ivpn
# Required packages: vpnc
# Required scripts: rc.app
# Description: vpn client of ipsec
. rc.app
PATH=$PATH:/usr/sbin
opt-d(){
    sudo vpnc-disconnect
    exit
}
_chkopt $* && shift
_chkarg $1 < <(db-list vpn) || shift $#
_usage "(-d:disconnect) [vpnhost]" $1
_temp config
cfg-ipsec $* > $config
sudo vpnc $config

