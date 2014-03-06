#!/bin/bash
#ip-up params:
#  interface-name
#  tty-device
#  speed
#  local-IP-address
#  remote-IP-address
#  ipparam
rtstr(){
    echo 'route add -net ${5%.*}.0 netmask 255.255.255.0 $1'
}
case "$1" in
    -i)
        . set.tempfile temp
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



