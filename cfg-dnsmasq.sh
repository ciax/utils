#!/bin/bash
# Usage: cfg-dnsmasq (subnet)
# Required TBL:mac (!id,device,if,hub,host,static-ip,alive,description)
# Required TBL:hub (!id,subnet,location,hub,description)
net=${1:-$(lookup-net)}
db-register <<< "select 'dhcp-host='||id,host from mac where hub in (select id from hub where subnet == '$net') and host not null;"
