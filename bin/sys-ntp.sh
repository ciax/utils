#!/bin/bash
#alias ntp
# Required packages: ntp ntpdate
# sys-ntp (-s) (server)

if [ "$1" = "-s" ] ; then
    server=${2:-pool.ntp.org}
    sudo /etc/init.d/ntp stop
    sudo ntpdate -b -u $server
    sudo /etc/init.d/ntp start
    sleep 1
fi
ntpq -p
