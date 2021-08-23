#!/bin/bash
# Show Global IPv6
date=$(date)
host=${1:-$(hostname)}
set - $(ip -6 address|grep global)
echo "${2%/*} $host"
