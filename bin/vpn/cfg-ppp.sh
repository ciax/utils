#!/bin/bash
# Required scripts: func.getpar func.temp
# Description: generate routing file for ppp
#*Config files take the following parameters at start up
#   interface-name
#   tty-device
#   speed
#   local-IP-address
#   remote-IP-address
#   ipparam
. func.getpar
. func.temp
opt-i(){ install=1; } #install
_usage
_temp temp
echo 'route add -net ${5%.*}.0 netmask 255.255.255.0 $1' > $temp
[ "$install" ] && sudo install $temp /etc/ppp/ip-up.d/route
cat $temp