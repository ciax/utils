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
    echo -en "$a.$b.$(($c+$sub)).$ip\t$host.$domain\t$host"
    [ "$another" -a "$host" != "$another" ] && echo -e "\t$another" || echo
done < <(
    db-exec <<EOF
select
    replace(subnet.network,'.','|'),subnet.sub_ip,host.host_ip,host.id,domain.name,ssh.id
from host
    inner join subnet on host.subnet=subnet.id
    inner join domain on subnet.domain=domain.id
    left outer join ssh on host.id=ssh.host
where
    $where
order by subnet.network,
      subnet.sub_ip,
      length(host.host_ip),
      host.host_ip
;
EOF
)
# FDQN alias
while read id fdqn; do
    ip=$(host $fdqn)
    ip=$(echo ${ip##* }|egrep '^([0-9]+\.?){4}$') || continue
    echo -e "$ip\t$fdqn\t$id"
done < <(db-exec 'select id,fdqn from ddns;')
# Global IP
cut -d ' ' -f 1,2 ~/cfg.def/etc/global.*.txt
# Global IPv6 : add '-6' to hostname
sed -e 's/$/-6/' ~/cfg.def/etc/ipv6.*.txt
