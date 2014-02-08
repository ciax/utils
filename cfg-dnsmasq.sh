#!/bin/bash
#Usage: cfg-dnsmasq (subnet)
net=${1:-$(lookup-net)}
echo "select 'dhcp-host='||id,host from mac where hub in (select id from hub where subnet == '$net') and host not null;"|db-device
