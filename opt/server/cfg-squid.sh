#!/bin/bash
. func.file
cfg=/etc/squid/squid.conf
eval $(info-net)
_insert $cfg 'acl localnet src' "$cidr"
_insert $cfg 'http_access allow localnet'
