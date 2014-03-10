#!/bin/bash
# Description: client for dd-wrt pptp server
# Required scripts: func.usage, db-list, db-setfield, cfg-ppp
#alias vpnp
[ "$1" = "-r" ] && { sudo kill $(< /var/run/ppp0.pid); exit; }
. func.usage "(-r:remove) [vpnhost]" $1 < <(db-list vpn)
. db-setfield $1 vpn
id="--create $1"
host="--server $remote"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cfg-ppp -i
sudo pptpsetup $id $host $user $pw $opt --start
