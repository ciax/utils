#!/bin/bash
# Required scripts: func.getpar db-list db-exec
# Required tables: host(host_ip),domain(name),subnet(network)
# Description: generate hosts file
# Usage: cfg-hosts | text-update
#alias hosts
. func.getpar
opt-a(){ #Show all list
    where="host.host_ip != ''"
}
xopt-s(){ $0 | text-update; }
_usage "(subnet)" $(db-list subnet)
_exe_opt
[ "$where" ] || {
    for net in ${1:-$(net-name)}; do
        subnet="$subnet and host.subnet != '$net'"
    done
    where="host.resolv == 'hosts' or (host.resolv =='dns'$subnet)"
}       
echo "#file /etc/hosts"
echo "127.0.1.1       $(hostname)"
echo "127.0.0.1       localhost.localdomain   localhost"
IFS='|'
db-exec <<EOF | while read a b c sub ip host domain; do [ "$ip" ] &&  echo "$a.$b.$(($c+$sub)).$ip    $host   $host.$domain";done
select
    replace(subnet.network,'.','|'),subnet.sub_ip,host.host_ip,host.id,domain.name
from host
    inner join subnet on host.subnet=subnet.id
    inner join domain on subnet.domain=domain.id
where
    $where
order by subnet.network,
      subnet.sub_ip,
      length(host.host_ip),
      host.host_ip
;
EOF
db-exec 'select ip,id,fdqn from ddns;' | while read ip id fdqn; do [ "$ip" ] || continue; echo "$ip    $id    $fdqn";done

