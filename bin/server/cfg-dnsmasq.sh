#!/bin/bash
# Required scripts: func.getpar net-name db-list db-exec
# Required tables: mac(hub,host) hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet) > /etc/dnsmasq.conf
. func.getpar
_usage "(subnet)" <(db-list subnet)
net=${1:-$(net-name)}
sub_hub="select id from hub where subnet == '$net'"
db-exec "select 'dhcp-host='||mac||','||id from host where hub in ($sub_hub);"
