#!/bin/bash
# Required scripts: rc.app, db-setfield
# Description: parsistent connection to vpn
. rc.app
client=vpn
pidfile=~/.var/vpn.pid
[ "$1" = "-d" ] && { kill $(< $pid); $client -d; exit; }
_usage "(-d:disconnect) [vpnhost] (pw)" $1
host="$1";shift
pw=$1;shift
. db-setfield $host vpn route
[ "$watch" ] || { echo "No such host"; exit 1; }
while sleep 5;do
    ping -c3 $watch > /dev/null 2>&1 || $client $host $pw
done &
echo $! > $pidfile
