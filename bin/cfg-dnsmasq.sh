#!/bin/bash
# Required scripts: net-name, db-exec
# Required tables: mac(hub,host),hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet)
. func.app
_usage "(subnet)" $(db-list subnet)
net=${1:-$(net-name)}
sub_hub="select id from hub where subnet == '$net'"
sub_host="select id from host where hub in ($sub_hub)"
db-exec "select 'dhcp-host='||id||','||host from mac where host in ($sub_host);"
