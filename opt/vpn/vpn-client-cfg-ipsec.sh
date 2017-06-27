#!/bin/bash
 # Required scripts: func.getpar db-list db-trace search-auth route-ipsec
# Required tables: subnet(network,netmask,vpn) vpn(login) login(command,user,password,host)
# Description: generate ipsec configulation text (for /etc/vpnc/default.conf)
. func.getpar
_usage "[vpn] (pw)" $(db-list vpn)
vid=$1;shift
eval "$(db-trace $vid vpn)"
[ "$id" ] || _abort "No such id"
eval "$(db-trace $ddns ddns)"
eval "$(db-trace $auth auth)"
echo "IPSec gateway $ip"
echo "IPSec ID $user"
echo "IPSec secret $(crypt-de <<< $password)"
#Uncomment line below for ver.5.3 usage
eval "$(db-trace $LOGNAME-pw-$vid auth)"
echo "Vendor netscreen"
echo "IKE Authmode psk"
echo "Xauth username $user"
echo "Xauth password $(crypt-de <<< $password)"
#Xauth password <password>
set - $(route-ipsec $route)
#echo "Target Networks $*"
echo "Nat Traversal Mode natt"
echo "local port 0"
