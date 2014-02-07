#!/bin/bash
mode="add"
[ "$1" = "-r" ] && { shift; mode="del"; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]"
while read res; do
    net=${res%,*}
    mask=${res#*,}
    echo "route $mode -net $net netmask $mask"
done < <(echo "select network,netmask from route where vpn = '$1';"|db-device)
