#!/bin/bash
#ln -s $0 /etc/vpnc/default.conf
[ "$1" ] || . set.usage "[vpn] [id] [pw]"
vid=$1
. set.field $vid vpn
. set.field $login login
[ "$command" = vpn ] || exit
echo "IPSec gateway $host"
echo "IPSec ID $user"
echo "IPSec secret $password"
#Uncomment line below for ver.5.3 usage
echo "Vendor netscreen"
# IKE Authmode hybrid
echo "Xauth username $2"
echo "Xauth password $3"
#Xauth password <password>
set - $(db-register "select network||'/'||netmask from subnet where vpn == '$vid';")
echo "Target Networks $*"
echo "Nat Traversal Mode natt"
