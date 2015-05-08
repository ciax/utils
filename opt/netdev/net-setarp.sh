#!/bin/bash
# Require scripts: func.getpar search-mac
# Description: Setting IP address for Devices
. func.getpar
opt-r(){
#   -r: arping only(root)
    sudo arping $mac;echo OK
}
opt-l(){
#   -l: setip for Lantronix
    sudo arp -s $ip $mac
    ping $ip -s 113
}
opt-p(){
#   -p: setip for PLIZZI
    sudo arp -s $ip $mac
    telnet $ip 1 >& /dev/null
    telnet $ip 9999
}
_usage "[hosts]"
IFS='|'
host="$1"
mac=$(search-mac $host)
echo "IP=$host  MAC=$mac"
_exe_opt || {
    sudo arp -s $host $mac
    ping $host
}
