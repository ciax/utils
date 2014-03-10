#!/bin/bash
# Description: generate ipsec configulation text (for /etc/vpnc/default.conf)
# Required scripts: func.usage, db-setfield, db-register
# Required tables: subnet(network,netmask,vpn),vpn(login),login(command,user,password,host)
. func.usage "[vpn] (id) (pw)" $1 < <(db-list vpn "where command == 'vpnc';")
vid=$1
. db-setfield  $vid vpn
[ "$id" ] || abort "No such id"
setfield $login login
[ "$command" = vpnc ] || exit
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
