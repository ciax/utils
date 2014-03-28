#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands
. rc.app
opt-r(){ mode="del"; }
mode="add"
_chkopt
_chkarg < <(db-list vpn)
set - "$ARGV"
_usage "(-r:remove) [vpnhost]" $1
db-register "select 'route $mode -net '||network||' netmask '||netmask from subnet where route == (select route from vpn where id == '$1');"
