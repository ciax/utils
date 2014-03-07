#!/bin/bash
pid=~/.var/vpn.pid
[ "$1" = "-r" ] && { kill $(< $pid); vpn -r; exit; }
. func.usage "(-r:remove) [vpnhost]" $1
host="$1"
alive=$(db-register "select alive from vpn where id = '$host';")
[ "$alive" ] || { echo "No such host"; exit 1; }
while sleep 5;do
    ping -c3 $alive > /dev/null 2>&1 || vpn-client $host
done &
echo $! > $pid
