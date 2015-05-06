#!/bin/bash
# Required scripts: func.getpar db-exec
# Required tables: mac
# Description: show mac address corresponding with host
. func.getpar
_usage "[host]"
db-exec <<EOF | head -1
select id from mac where host='$1';
EOF
