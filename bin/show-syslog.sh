#!/bin/bash
#alias syslog
# Required commands: sudo,grep,tail
# Description: show syslog file
if [ "$1" ]; then
    sudo grep "$1" /var/log/syslog
else
    sudo tail /var/log/syslog
fi