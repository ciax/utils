#!/bin/bash
pid=~/.var/vpn.pid
[ "$1" = "-r" ] && { kill $(< $pid); vpn -r; exit; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]"
host="$1"
alive=`echo "select alive from vpn where id = '$host';"|db-device`
[ "$alive" ] || { echo "No such host"; exit 1; }
while sleep 5;do
    ping -c3 $alive > /dev/null 2>&1 || vpn-client $host
done &
echo $! > $pid
