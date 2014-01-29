#!/bin/bash
db=~/.var/db-device.sq3
sqlite3 $db <<EOF
select id from subnet where network == '`subnet`';
EOF

