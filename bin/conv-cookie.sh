#!/bin/bash
# Original script to get content using Firefox cookies. by Jean-Sebastien Morisset (http://surniaulula.com/)
[ "$1" ] || { echo "Usage: conv-cookie [sqlfile]";exit; }
sqlite3 $1 <<EOF
.mode tabs
select host, case when host glob '.*' then 'TRUE' else 'FALSE' end,
path, case when isSecure then 'TRUE' else 'FALSE' end,
expiry, name, value from moz_cookies;
EOF
