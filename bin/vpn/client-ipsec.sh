#!/bin/bash
# Required packages: vpnc
# Description: vpn client of ipsec
_usage "[vpnhost]" $1 < <(db-list vpn)
_temp config
cfg-ipsec $* > $config
PATH=$PATH:/usr/sbin
sudo vpnc-disconnect
sudo vpnc $config

