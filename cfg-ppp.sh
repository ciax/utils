#!/bin/bash
case "$1" in
    -i)
        . set.tempfile temp
        tail -4 $0 > $temp
        sudo install $temp /etc/ppp/ip-up.d/route
        ;;
    '')
        tail -4 $0
        ;;
    *)
        . set.usage "(-i:install)"
        ;;
esac
exit

#ip-up params: interface-name tty-device speed local-IP-address remote-IP-address ipparam
#!/bin/sh
ifname=$1
rnet=${5%.*}.0
route add -net $rnet netmask 255.255.255.0 $ifname
