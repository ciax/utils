#!/bin/bash
# Required scripts: func.getpar net-name db-exec db-list
# Required tables: mac(hub,host) hub(subnet)
# Description: generate bootp config
# Usage: cfg-bootp (subnet) > /etc/bootptab
. func.getpar
_usage "(subnet)" <(db-list subnet)
echo "#/etc/bootptab"
net=${1:-$(net-name)}
db-exec <<EOF
select
  host.id||':ha='||replace(mac.id,':','')
from host
  inner join mac on mac.host=host.id
where hub in (
  select id from hub where subnet == '$net'
)
;
EOF
