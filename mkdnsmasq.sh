#!/bin/bash
#Usage: mkdnsmasq (subnet)
db=~/.var/db-device.sq3
net=${1:-`mynet`}
sqlite3 -csv $db <<EOF
select 'dhcp-host='||id,host from mac where hub in (select id from hub where subnet == '$net') and host not null;
EOF

