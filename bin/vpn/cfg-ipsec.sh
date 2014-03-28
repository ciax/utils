#!/bin/bash
# Required scripts: rc.app, db-setfield, db-register
# Required tables: subnet(network,netmask,vpn),vpn(login),login(command,user,password,host)
# Description: generate ipsec configulation text (for /etc/vpnc/default.conf)
. rc.app
_chkarg < <(db-list vpn)
set - "$ARGV"
_usage "[vpn] (pw)" $1
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
set - $(route-ipsec $route)
echo "Target Networks $*"
echo "Nat Traversal Mode natt"
