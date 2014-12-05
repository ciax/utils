#!/bin/bash
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.getpar
_usage "[host]"
set - $(search-mac $1)
if [ "$1" ] ; then
    mac="${*,,*}"
    mac="${mac// /|}"
    eval "$(info-net)"
    ping -c2 -b $bcast > /dev/null 2>&1
    arp -n|egrep "($mac)"
fi

