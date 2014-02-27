#!/bin/bash
#Usage: mkdnsmasq (subnet)
#Required packages: wakeonlan
[ "$1" ] || . set.usage "[host]"
mac=$(echo "select id from mac where host == '$1';"|db-register)
wakeonlan $mac
