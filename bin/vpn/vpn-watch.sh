#!/bin/bash
# Description: parsistent connection to vpn
# Required scripts: func.usage, db-setfield
client=vpn
pidfile=~/.var/vpn.pid
[ "$1" = "-r" ] && { kill $(< $pid); $client -r; exit; }
. func.usage "(-r:remove) [vpnhost]" $1
host="$1"
. db-setfield $host vpn
[ "$watch" ] || { echo "No such host"; exit 1; }
while sleep 5;do
    ping -c3 $watch > /dev/null 2>&1 || $client $host
done &
echo $! > $pidfile
