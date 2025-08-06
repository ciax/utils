#!/bin/bash
# Required scripts: func.getpar db-list db-exec
# Required tables: host(host_ip),domain(name),subnet(network)
# Description: lookup ip by hostname
# Usage: info-host [hostname]
#alias hostdb
. func.getpar
query(){
    db-exec <<EOF
select
    subnet.network,subnet.sub_ip+host.host_ip
from host
    inner join subnet on host.subnet=subnet.id
where
    host.host_ip != '' AND host.id == '$1'
;
EOF
}

_usage "(hostname)" $(db-list host)
_exe_opt
IFS='|'
while read a b others; do
    echo -e "$a.$b"
done < <(query "$1")|grep .
