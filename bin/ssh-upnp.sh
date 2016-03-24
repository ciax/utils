#!/bin/bash
# Required scripts: info-net
# Required packages: miniupnpc
# Description: request ssh port forwarding to router
. func.getpar
_usage "[wan port base]"
eval $(info-net)
port=$(( $1 + ${hostip##*.}))
echo "Requesting ssh port forwarding to wan:$port"
upnpc -a $hostip 22 $port tcp
