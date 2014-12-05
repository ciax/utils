#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: mac(host)
# Description: show hosts which belong to same subnet
. func.getpar
eval "$(info-net)"
db-exec <<EOF
select id from host where hub in (
  select id from hub where subnet == (
    select id from subnet where network == '$subnet'
  )
)
;
EOF
