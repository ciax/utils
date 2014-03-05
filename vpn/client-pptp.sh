#!/bin/bash
#alias vpnp
[ "$1" = "-r" ] && { sudo kill $(< /var/run/ppp0.pid); exit; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]" < <(db-list vpn)
. set.field "'$1'" vpn
id="--create $1"
host="--server $remote"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cfg-ppp -i
sudo pptpsetup $id $host $user $pw $opt --start
