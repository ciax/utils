#!/bin/bash
# Description: check hub failure
# Required scripts: rc.app, db-register, info-subnet
# Required tables: hub, subnet(network)
. rc.app
chkhost(){
    local chk
    for host in $(db-register "select host from mac where hub == '$1';"); do
        ping -c1 -w1 $host &>/dev/null && return
        chk=1
    done
    [ "$chk" ] || return
    db-register "select id||'('||description||') is Down' from hub where id == '$1';"
    fail=1
}
_usage "[subnet]" $1 < <(db-list subnet)
for hub in $(db-register "select id from hub where subnet == '$1';"); do
    chkhost $hub
done
[ "$fail" ] || echo "All Hub is OK"
