#!/bin/bash
# Required scripts: net-name, db-exec
# Required tables: mac(hub,host),hub(subnet)
# Description: generate dnsmasq config
# Usage: cfg-dnsmasq (subnet)
net=${1:-$(net-name)}
subq="select id from hub where subnet == '$net'"
db-exec "select 'dhcp-host='||id||','||host from mac where hub in ($subq) and host not null;"
