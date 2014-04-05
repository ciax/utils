#!/bin/bash
#alias pvpn
# Required commands: kill,pptpsetup
# Required scripts: func.app, db-list, db-trace, cfg-ppp
# Description: client for dd-wrt pptp server
. func.app
# Options
opt-d(){ sudo kill $(< /var/run/ppp0.pid);exit; }
_chkarg $(db-list vpn)
_usage "(-d:disconnect) [vpnhost]"
_selflink vpn
eval "$(db-trace $1 vpn)"
eval "$(db-trace $host host)"
id="--create $1"
host="--server $fdqn"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cmd="sudo pptpsetup $id $host $user $pw $opt --start"
cfg-ppp -i
echo $cmd
$cmd
