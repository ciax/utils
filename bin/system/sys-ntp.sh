#!/bin/bash
#alias ntp
# Required packages: ntp ntpdate
# sys-ntp (-s) (server)

if [ "$1" = "-s" ] ; then
    [ "$2" ] || set - $(egrep "^server" /etc/ntp.conf)
    server=$2
    sudo /etc/init.d/ntp stop
    sudo ntpdate -b -u $server
    sudo /etc/init.d/ntp start
    sleep 1
fi
ntpq -p
