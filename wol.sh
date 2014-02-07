#!/bin/bash
#Usage: mkdnsmasq (subnet)
#Required packages: wakeonlan
[ "$1" ] || . set.usage "[host]"
mac=$(db-device<<EOF
select id from mac where host == '$1';
EOF
)
wakeonlan $mac
