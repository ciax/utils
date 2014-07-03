#!/bin/bash
# Required scripts: db-exec info-subnet
# Required tables: mac(network)
# Description: search IP addres by mac
#alias mac
. func.getpar
if [ "$1" ]; then
    set - $(db-exec "select id from mac where device == '$1';")
    IFS="|"
    mac="$*"
    if [ "$mac" ] ; then
      mac="${mac,,*}"
      mac="${mac// /|}"
      ping -q -c2 -b 133.40.147.255 > /dev/null 2>&1
      arp -n|egrep "$mac"
    fi
fi
_usage "[device]"



