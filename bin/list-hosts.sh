#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: mac hab
# Description: show hosts which belong to same subnet
. func.getpar
opt-e(){ #exclude anonymous hosts
    rstr="and host_ip > 0"
}
_usage "(subnet)"
subnet="${1:-$(net-name)}"
_exe_opt
for net in $subnet; do
    db-exec <<EOF
select host from mac where hub in (
  select id from hub where subnet == '$net' $rstr
)
;
EOF
done
