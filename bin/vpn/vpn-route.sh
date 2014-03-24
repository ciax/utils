#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands
. rc.app
mode="add"
[ "$1" = "-r" ] && { shift; mode="del"; }
_usage "(-r:remove) [vpnhost]" $1 < <(db-list vpn)
db-register "select 'route $mode -net '||network||' netmask '||netmask from subnet where route == (select route from vpn where id == '$1');"
