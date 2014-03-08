#!/bin/bash
# Usage: cfg-dnsmasq (subnet)
# Required scripts: net-name, db-register
# Required tables: mac(hub,host),hub(subnet)
net=${1:-$(net-name)}
subq="select id from hub where subnet == '$net'"
db-register "select 'dhcp-host='||id||','||host from mac where hub in ($subq) and host not null;"
