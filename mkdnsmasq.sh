#!/bin/bash
#Usage: mkdnsmasq (subnet)
net=${1:-`mynet`}
db-device <<EOF
select 'dhcp-host='||id,host from mac where hub in (select id from hub where subnet == '$net') and host not null;
EOF


