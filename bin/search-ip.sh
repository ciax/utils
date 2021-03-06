#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host
# Description: show hosts which belong to same subnet
. func.getpar
_usage "[host]"
set - $(
    db-exec <<EOF
select
    replace(subnet.network,'.',' ')||' '||subnet.sub_ip||' '||host.host_ip
from host
    inner join subnet on host.subnet=subnet.id
where
    host.id == '$1'
;
EOF
)
if [ "$5" ]
then
    echo "$1.$2.$(($3 + $4)).$5"
fi
