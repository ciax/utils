#!/bin/bash
# Required scripts: rc.app, db-register
# Required tables: subnet(network,netmask,vpn)
# Description: Generate routing commands
. rc.app
mode="add"
opt-r(){ mode="del"; }
_chkarg $(db-list vpn)
_usage "(-r:remove) [vpnhost]"
db-register "select 'route $mode -net '||network||' netmask '||netmask from subnet where route == (select route from vpn where id == '$1');"
