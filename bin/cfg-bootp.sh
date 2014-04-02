#!/bin/bash
# Required scripts: net-name, db-exec
# Required tables: mac(hub,host),hub(subnet)
# Description: generate bootp config
# Usage: cfg-bootp (subnet) > /etc/bootptab
. func.app
_usage "(subnet)" $(db-list subnet)
net=${1:-$(net-name)}
sub_hub="select id from hub where subnet == '$net'"
sub_host="select id from host where hub in ($sub_hub)"
db-exec "select host||':ha='||replace(id,':','')  from mac where host in ($sub_host);"
