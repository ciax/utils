#!/bin/bash
#alias syslog
# Description: show syslog file
if [ "$1" ]; then
    sudo grep "$1" /var/log/syslog
else
    sudo tail -f /var/log/syslog
fi
