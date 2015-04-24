#!/bin/bash
# Required scripts: func.getpar net-name db-list db-exec
# Required tables: mac(hub,host) hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet) > /etc/dnsmasq.conf
. func.getpar
_usage "(subnet)" <(db-list subnet)
echo "#/etc/dnsmasq.conf"
net=${1:-$(net-name)}
db-exec <<EOF
select
  'dhcp-host='||mac.id||','||host.id
from host
  inner join mac on mac.host=host.id
where host.hub in (
  select id from hub where subnet == '$net'
)
;
EOF
