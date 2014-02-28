#!/bin/bash
mode="add"
[ "$1" = "-r" ] && { shift; mode="del"; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]"
db-register "select 'route $mode -net '||network||' netmask '||netmask from subnet where vpn == '$1';"
