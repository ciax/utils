#!/bin/bash
#Usage: mkdnsmasq (subnet)
db=~/.var/db-device.sq3
[ "$1" ] || . set.usage "[host]"
mac=$(sqlite3 $db <<EOF
select id from mac where host == '$1';
EOF
)
wakeonlan $mac
