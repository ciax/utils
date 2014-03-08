#!/bin/bash
# Description: Generate routing commands
# Required scripts: func.usage, db-register
# Required tables: subnet(network,netmask,vpn)
mode="add"
[ "$1" = "-r" ] && { shift; mode="del"; }
. func.usage "(-r:remove) [vpnhost]" $1
db-register "select 'route $mode -net '||network||' netmask '||netmask from subnet where vpn == '$1';"
