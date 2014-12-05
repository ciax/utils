#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: host(mac)
# Description: show mac address corresponding with host
. func.getpar
_usage "[host]"
db-exec <<EOF
select mac from host where id='$1';
EOF
