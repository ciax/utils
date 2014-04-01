#!/bin/bash
# Required scripts: rc.app, db-trace
# Description: parsistent connection to vpn
. rc.app
client=vpn
pidfile=~/.var/vpn.pid
[ "$1" = "-d" ] && { kill $(< $pid); $client -d; exit; }
_usage "(-d:disconnect) [vpnhost] (pw)"
host="$1";shift
pw=$1;shift
eval "$(db-trace $host vpn route)"
[ "$watch" ] || _abort "No such host"
while sleep 5;do
    ping -c3 $watch > /dev/null 2>&1 || $client $host $pw
done &
echo $! > $pidfile
