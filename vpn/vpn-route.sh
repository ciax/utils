#!/bin/bash
mode="add"
[ "$1" = "-r" ] && { shift; mode="del"; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]"
echo "select 'route $mode -net '||network||' netmask '||netmask from route where vpn = '$1';"|db-device
