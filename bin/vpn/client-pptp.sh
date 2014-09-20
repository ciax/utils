#!/bin/bash
#alias pvpn
# Required packages(Debian,Raspbian): pptp-linux
# Required scripts: func.getpar db-list db-trace cfg-ppp
# Description: client for dd-wrt pptp server
. func.getpar
# Options
xopt-d(){ #disconnect
    [ -s /var/run/ppp0.pid ] && sudo kill $(< /var/run/ppp0.pid) && echo "PPTP Terminated"
}
_usage "[vpnhost]" <(db-list vpn)
eval "$(db-trace $1 vpn)"
eval "$(db-trace $host host)"
id="--create $1"
host="--server $static_ip"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
cmd="sudo pptpsetup $id $host $user $pw $opt --start"
cfg-ppp -i
echo $cmd
$cmd && ln -sf $(readlink $0) ~/bin/vpn