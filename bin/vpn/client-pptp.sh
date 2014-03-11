#!/bin/bash
# Description: client for dd-wrt pptp server
# Required scripts: func.usage, db-list, db-setfield, cfg-ppp
#alias vpnp
[ "$1" = "-d" ] && { sudo kill $(< /var/run/ppp0.pid); exit; }
. func.usage "(-d:disconnect) [vpnhost]" $1 < <(db-list vpn)
. db-setfield $1 vpn login
id="--create $1"
host="--server $host"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cmd="sudo pptpsetup $id $host $user $pw $opt --start"
cfg-ppp -i
echo $cmd
$cmd