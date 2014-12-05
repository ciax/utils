#!/bin/bash
# Required scripts: func.getpar net-name db-exec db-list
# Required tables: mac(hub,host) hub(subnet)
# Description: generate bootp config
# Usage: cfg-bootp (subnet) > /etc/bootptab
. func.getpar
_usage "(subnet)" <(db-list subnet)
net=${1:-$(net-name)}
sub_hub="select id from hub where subnet == '$net'"
db-exec "select id||':ha='||replace(mac,':','')  from host where hub in ($sub_hub);"
