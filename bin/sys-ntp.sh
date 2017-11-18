#!/bin/bash
#alias ntp
# Required packages: ntp ntpdate
# sys-ntp (-s) (server)
# general server is 'pool.ntp.org'
[ -f /etc/ntp.conf ] || { echo "No ntp config file"; exit; }
if [ "$1" = "-s" ] ; then
    [ "$2" ] || set $(grep '^server' /etc/ntp.conf|head -1)
    sudo /etc/init.d/ntp stop
    sudo ntpdate -b -u $2
    sudo /etc/init.d/ntp start
    sleep 1
fi
ntpq -p
