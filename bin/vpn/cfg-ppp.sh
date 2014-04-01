#!/bin/bash
# Required scripts: func.app
# Description: generate routing file for ppp

#*Config files take the following parameters at start up
#   interface-name
#   tty-device
#   speed
#   local-IP-address
#   remote-IP-address
#   ipparam
. func.app
rtstr(){
    echo 'route add -net ${5%.*}.0 netmask 255.255.255.0 $1'
}
case "$1" in
    -i)
        _temp temp
        rtstr > $temp
        sudo install $temp /etc/ppp/ip-up.d/route
        ;;
    '')
        rtstr $0
        ;;
    *)
        _usage "(-i:install)"
        ;;
esac



