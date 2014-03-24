#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for openvpn
. rc.app
_usage "(-r:remove) [vpnhost]" $1 < <(db-list vpn)
db-register "select 'route '||network||' '||netmask from subnet where route == (select route from vpn where id == '$1');"
