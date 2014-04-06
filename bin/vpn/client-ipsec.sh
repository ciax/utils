#!/bin/bash
#alias ivpn
# Required commands: sudo,vpnc
# Required scripts: func.app,cfg-ipsec
# Description: vpn client of ipsec
. func.app
PATH=$PATH:/usr/sbin
opt-d(){ sudo vpnc-disconnect;exit; } #disconnect
_usage "[vpnhost]" $(db-list vpn)
_selflink vpn
_temp config
cfg-ipsec $* > $config
sudo vpnc $config

