#!/bin/bash
#alias syslog
# Description: show syslog file
. func.sudo
if [ "$1" ]; then
    _sudy grep "$1" /var/log/syslog
else
    _sudy tail -f /var/log/syslog
fi
