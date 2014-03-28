#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands for ipsec
. rc.app
_chkarg < <(db-list vpn)
set - "$ARGV"
_usage "[vpnhost]" $1
db-register "select network||'/'||netmask from subnet where route == '$1';"
