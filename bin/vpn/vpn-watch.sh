#!/bin/bash
# Requied commands: ping
# Required scripts: func.app, db-trace
# Description: parsistent connection to vpn
. func.app
opt-d(){
    kill $(< $pidfile)
    $client -d
    exit
}
client=vpn
pidfile=~/.var/vpn.pid
_usage "(-d:disconnect) [vpnhost] (pw)"
host="$1";shift
pw=$1;shift
eval "$(db-trace $host vpn route)"
[ "$watch" ] || _abort "No such host"
while sleep 5;do
    ping -c3 $watch > /dev/null 2>&1 || $client $host $pw
done &
echo $! > $pidfile
