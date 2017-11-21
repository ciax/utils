#!/bin/bash
# Require scripts: func.getpar search-mac
# Description: Setting IP address for Devices
#alias setarp
. func.getpar
opt-r(){ # arping only(root)
    sudo arping $mac;echo OK
}
opt-l(){ # setip for Lantronix/APC PDU
    sudo arp -s $ip $mac
    ping $ip -s 113
}
opt-p(){ # setip for PLIZZI
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
