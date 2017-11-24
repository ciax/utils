#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: mac
# Description: show mac address corresponding with host
. func.getpar
while read a b mac c; do
    [[ "$mac" =~ : ]] || continue
    db-exec <<EOF | grep -q .|| echo "$mac"
select id from mac where id='${mac^^}';
EOF
done < <(arp)
