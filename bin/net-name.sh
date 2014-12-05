#!/bin/bash
# Required scripts: db-exec info-net
# Required tables: subnet(network)
# Description: lookup network name
#alias mynet
eval $(info-net)
db-exec <<EOF
select id
from subnet
where
  network == '$subnet'
;
EOF
