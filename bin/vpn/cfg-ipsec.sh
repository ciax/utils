#!/bin/bash
# Required scripts: rc.app, db-setfield, db-register
# Required tables: subnet(network,netmask,vpn),vpn(login),login(command,user,password,host)
# Description: generate ipsec configulation text (for /etc/vpnc/default.conf)
. rc.app
_usage "[vpn] (pw)" $1 < <(db-list vpn)
vid=$1;shift
. db-setfield  $vid vpn
[ "$id" ] || _abort "No such id"
setfield $host host
echo "IPSec gateway $static_ip"
echo "IPSec ID $user"
echo "IPSec secret $password"
#Uncomment line below for ver.5.3 usage
echo "Vendor netscreen"
# IKE Authmode hybrid
echo "Xauth username $LOGNAME"
echo "Xauth password $1"
#Xauth password <password>
set - $(db-register "select network||'/'||netmask from subnet where route == '$route';")
echo "Target Networks $*"
echo "Nat Traversal Mode natt"
