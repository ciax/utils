#!/bin/bash
# Required scripts: func.app, db-trace
# Required tables: subnet(network,netmask,vpn),vpn(login),login(command,user,password,host)
# Description: generate ipsec configulation text (for /etc/vpnc/default.conf)
. func.app
_chkarg $(db-list vpn)
_usage "[vpn] (pw)"
vid=$1;shift
eval "$(db-trace $vid vpn)"
[ "$id" ] || _abort "No such id"
eval "$(db-trace $host host)"
echo "IPSec gateway $static_ip"
echo "IPSec ID $user"
echo "IPSec secret $password"
#Uncomment line below for ver.5.3 usage
echo "Vendor netscreen"
# IKE Authmode hybrid
echo "Xauth username $LOGNAME"
echo "Xauth password $1"
#Xauth password <password>
set - $(route-ipsec $route)
echo "Target Networks $*"
echo "Nat Traversal Mode natt"
