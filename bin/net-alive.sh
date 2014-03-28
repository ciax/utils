#!/bin/bash
# Description: check hub failure
# Required scripts: rc.app, db-register, info-subnet
# Required tables: hub, subnet(network)
. rc.app
_chkarg < <(db-list subnet)
set - "$ARGV"
_usage "[subnet]" $1
for hub in $(db-register "select id from hub where subnet == '$1';"); do
    for host in $(db-register "select host from mac where hub == '$hub';"); do
        ping -c1 -w1 $host &>/dev/null && break
        false
    done && continue
    db-register "select id||'('||description||') is Down' from hub where id == '$hub';"
    fail=1
done
[ "$fail" ] || echo "All Hub is OK"
