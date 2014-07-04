#!/bin/bash
# Required scripts: db-exec info-net
# Required tables: mac(network)
# Description: search IP addres by mac
#alias mac
. func.getpar
if [ "$1" ]; then
    set - $(db-exec "select id from mac where device == '$1';")
    if [ "$1" ] ; then
        mac="${*,,*}"
        mac="${mac// /|}"
        eval "$(info-net)"
        ping -c2 -b $bcast > /dev/null 2>&1
        arp -n|egrep "($mac)"
    fi
fi
_usage "[device]"
