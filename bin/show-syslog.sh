#!/bin/bash
# Description: show syslog file
# Required packages: coreutils(grep,tail)
#alias syslog
if [ "$1" ]; then
    sudo grep "$1" /var/log/syslog
else
    sudo tail /var/log/syslog
fi