#!/bin/bash
# Description: generate routing file for ppp
# Required scripts: func.temp, func.usage
#
#*Config files take the following parameters at start up
#   interface-name
#   tty-device
#   speed
#   local-IP-address
#   remote-IP-address
#   ipparam
rtstr(){
    echo 'route add -net ${5%.*}.0 netmask 255.255.255.0 $1'
}
case "$1" in
    -i)
        . func.temp temp
        rtstr > $temp
        sudo install $temp /etc/ppp/ip-up.d/route
        ;;
    '')
        rtstr $0
        ;;
    *)
        . func.usage "(-i:install)"
        ;;
esac



