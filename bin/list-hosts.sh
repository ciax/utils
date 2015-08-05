#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host
# Description: show hosts which belong to same subnet
. func.getpar
opt-d(){
    rstr="and assign == 'dhcp'"
}
subnet="${1:-$(net-name)}"
_exe_opt
for net in $subnet; do
    db-exec <<EOF
select id from host where hub in (
  select id from hub where subnet == '$net' $rstr
)
;
EOF
done
