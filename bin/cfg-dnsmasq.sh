#!/bin/bash
# Usage: cfg-dnsmasq (subnet)
# Required TBL:mac (!id,device,if,hub,host,static-ip,alive,description)
# Required TBL:hub (!id,subnet,location,hub,description)
net=${1:-$(net-name)}
subq="select id from hub where subnet == '$net'"
db-register "select 'dhcp-host='||id||','||host from mac where hub in ($subq) and host not null;"
