#!/bin/bash
# Required scripts: func.app, db-exec
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for ipsec
. func.app
_usage "[vpnhost]" $(db-list vpn)
db-exec "select network||'/'||netmask from subnet where route == '$1';"
