#!/bin/bash
# Required scripts: func.getpar net-name db-list db-exec
# Required tables: mac(hub,host) hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet) > /etc/dnsmasq.conf
. func.getpar
_usage "(subnet)" $(db-list subnet)
net=${1:-$(net-name)}
echo "#/etc/dnsmasq.conf"
db-exec <<EOF | grep . | sort
select
  mac.id||' , '||host.id||' , '||host.host_ip
from host
  inner join mac on mac.host=host.id
where subnet == '$net'
;
EOF
