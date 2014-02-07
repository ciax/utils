#!/bin/bash
db-device <<EOF
select id from subnet where network == '`subnet`';
EOF

