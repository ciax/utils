#!/bin/bash
# Required scripts: func.app, db-exec
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for openvpn
. func.app
_chkarg $(db-list vpn)
_usage "[vpnhost]"
db-exec "select 'route '||network||' '||netmask from subnet where route == (select route from vpn where id == '$1');"
