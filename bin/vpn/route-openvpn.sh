#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for openvpn
. func.getpar
_usage "[vpnhost]" <(db-list vpn)
db-exec "select 'route '||network||' '||netmask from subnet where route == (select route from vpn where id == '$1');"
