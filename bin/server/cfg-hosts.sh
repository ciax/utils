#!/bin/bash
# Required scripts: func.getpar net-name db-list db-exec
# Required tables: mac(hub,host) hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet) > /etc/dnsmasq.conf
. func.getpar
_usage "(subnet)" <(db-list subnet)
net=${1:-$(net-name)}
db-exec <<EOF
select
    rtrim(subnet.network,'.0')
    ||'.'
    ||host.host_ip
    ||'    '
    ||host.id
    ||'    '
    ||host.id
    ||'.'
    ||domain.name
from host
    inner join subnet on host.subnet=subnet.id
    inner join domain on subnet.domain=domain.id
where
    host.assign == 'static' or host.assign == 'wan'
order by subnet.network,
      length(host.host_ip),
      host.host_ip
;
EOF
