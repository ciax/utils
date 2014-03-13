#!/bin/bash
# Required packages: vpnc
# Description: vpn client of ipsec
. func.usage "[vpnhost]" $1 < <(db-list vpn)
. func.temp config
cfg-ipsec $* > $config
PATH=$PATH:/usr/sbin
sudo vpnc-disconnect
sudo vpnc $config

