#!/bin/bash
if [ "$1" ]; then
    sudo grep "$1" /var/log/syslog
else
    sudo tail /var/log/syslog
fi