#!/bin/bash
[ -e "$1" ] || . set.usage "[salite3 file] [hub]"
echo "select 'dhcp-host='||id,host from mac where hub == '${2:-kimo}';"|sqlite3 -csv $1

