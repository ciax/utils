#!/bin/bash
# Required scripts: info-net
# Required packages: miniupnpc
# Description: request ssh port forwarding to router
. func.getpar
_usage "[wan port]"
eval $(info-net)
upnpc -a $hostip 22 $1 tcp
