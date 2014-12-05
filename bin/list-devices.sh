#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host,mac,category,mfr,model,location
# Description: show device list with mac
#alias devices
. func.getpar
_usage "[subnet]" <(db-list subnet)
db-exec -c <<EOF
select
    host.host_ip,
    host.id,
    mac.id,
    category.description,
    mfr.description,
    model."p/n",
    location.description,
    host.description
from host
    inner join mac on host.mac=mac.id
    inner join device on mac.device=device.id
    inner join model on device.model=model.id
    inner join category on model.category=category.id
    inner join mfr on model.mfr=mfr.id
    inner join location on device.location=location.id
where
    host.hub in (
        select id from hub where subnet == '$1'
    )
order by length(host.host_ip),host.host_ip
;
EOF
