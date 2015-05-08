#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for ipsec
. func.getpar
_usage "[vpnhost]" < <(db-list vpn)
db-exec "select network||'.0/'||netmask from subnet where route == '$1';"
