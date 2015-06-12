#!/bin/bash
# Required scripts: func.getpar db-list db-exec
# Required tables: host(host_ip),domain(name),subnet(network)
# Description: generate hosts file
# Usage: cfg-hosts > /etc/hosts
. func.getpar
xopt-s(){ #Set to /etc/hosts
    $0 | _overwrite /etc/hosts || _warn "No changes on /etc/hosts"
}
_usage "(subnet)" $(db-list subnet)
echo "#/etc/hosts"
echo "127.0.1.1       $(hostname)"
echo "127.0.0.1       localhost.localdomain   localhost"
net=${1:-$(net-name)}
IFS='|'
db-exec <<EOF | while read a b c sub ip host domain; do echo "$a.$b.$(($c+$sub)).$ip    $host   $host.$domain";done
select
    replace(subnet.network,'.','|'),subnet.sub_ip,host.host_ip,host.id,domain.name
from host
    inner join subnet on host.subnet=subnet.id
    inner join domain on subnet.domain=domain.id
where
    host.resolv == 'hosts' or (host.subnet != '$net' and host.resolv == 'dns')
order by subnet.network,
      length(host.host_ip),
      host.host_ip
;
EOF
