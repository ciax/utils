#!/bin/bash
# Required scripts: func.getpar db-list db-exec
# Required tables: host(host_ip),domain(name),subnet(network)
# Description: generate hosts file
# Usage: cfg-hosts > /etc/hosts
. func.getpar
_usage "(subnet)" <(db-list subnet)
echo "#/etc/hosts"
echo "127.0.0.1       localhost.localdomain   localhost"
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
