#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for openvpn
. rc.app
_chkarg $(db-list vpn)
_usage "[vpnhost]"
set - $ARGV
db-register "select 'route '||network||' '||netmask from subnet where route == (select route from vpn where id == '$1');"
