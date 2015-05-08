#!/bin/bash
# Required scripts: func.getpar
# Description: generate routing file for ppp
#*Config files take the following parameters at start up
#   interface-name
#   tty-device
#   speed
#   local-IP-address
#   remote-IP-address
#   ipparam
. func.getpar
opt-i(){ sudo install $temp /etc/ppp/ip-up.d/route; } #install
_usage
_temp temp
echo 'route add -net ${5%.*}.0 netmask 255.255.255.0 $1' > $temp
_exe_opt
cat $temp
