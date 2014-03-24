#!/bin/bash
#alias pvpn
# Required scripts: rc.app, db-list, db-setfield, cfg-ppp
# Description: client for dd-wrt pptp server
. rc.app
[ "$1" = "-d" ] && { sudo kill $(< /var/run/ppp0.pid); exit; }
_usage "(-d:disconnect) [vpnhost]" $1 < <(db-list vpn)
. db-setfield $1 vpn
setfield $host host
id="--create $1"
host="--server $fdqn"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cmd="sudo pptpsetup $id $host $user $pw $opt --start"
cfg-ppp -i
echo $cmd
$cmd
