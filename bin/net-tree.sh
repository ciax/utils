#!/bin/bash
# Description: show hub tree
# Required scripts: rc.app, db-registe
# Required tables: hub,subnet
. rc.app
_usage "[subnet]" $1 < <(db-list subnet)
for hub in $(db-register "select id,upper from hub where subnet == '$1';"); do
    if [[ "$hub" =~ '|' ]] ;then
        upper="${hub#*|}"
        hub="${hub%|*}"
        db-register "select description from hub where id == '$upper';"
        echo "  |- $hub"
    else
        echo "$hub"
    fi
done
