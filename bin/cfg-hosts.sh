#!/bin/bash
# Required packages: bind9-host
# Required scripts: func.getpar db-list db-exec
# Required tables: host(host_ip),domain(name),subnet(network)
# Description: generate hosts file
# Usage: cfg-hosts | text-update
#alias hosts
. func.getpar
opt-a(){ #Show all list
    where="host.host_ip != ''"
}
xopt-s(){ #Write to /etc/hosts
    $0 | text-update
}
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
while read a b c sub ip host domain another; do
    [ "$ip" ] || continue
    echo -e "$a.$b.$(($c+$sub)).$ip\t$host.$domain\t$host"
done < <(
    db-exec <<EOF
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
)
echo "# FDQN alias"
while read id fdqn; do
    [ "$fdqn" ] || continue
    ip=$(host $fdqn)
    ip=$(echo ${ip##* }|egrep '^([0-9]+\.?){4}$') || continue
    echo -e "$ip\t$fdqn\t$id"
done < <(db-exec 'select id,fdqn from ddns;')
echo "# Global IP"
txt=~/etc/global.*.txt
[ "$(eval echo $txt)" ] && cut -d ' ' -f 1,2 $txt
echo "# Global IPv6"
# Global IPv6 : add '-6' to hostname
txt=~/etc/ipv6.*.txt
[ "$(eval echo $txt)" ] && sed -e 's/$/-6/' $txt 
