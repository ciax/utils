#!/bin/bash
#alias wol
# Required packages(Debian,Raspbian,Ubuntu): wakeonlan ethtool
# Required scripts: func.getpar search-mac
# Description: make network devices wake up
. func.getpar
xopt-s(){
    if sudo ethtool eth0 | grep -q 'Wake-on: d' ; then
        sudo ethtool -s eth0 wol g
        _warn "Wake on lan is set"
    fi
}
_usage "[host]" $(list-hosts)

wakeonlan $(search-mac $1)
