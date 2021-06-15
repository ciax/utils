#!/bin/bash
# Show Global IPv6
host=$(hostname)
set - $(ip -6 address|grep global)
echo "${2%/*} $host"
