#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: mac(host)
# Description: show hosts which belong to same subnet
. func.getpar
_usage "[host]"
db-exec <<EOF
select
    rtrim(subnet.network,'.0')||'.'||host.host_ip
from host
    inner join subnet on host.subnet=subnet.id
where
    host.id == '$1'
;
EOF
