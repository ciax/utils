#!/bin/bash
# Show Global IP
# Required packages: curl
date=$(date)
host=$(hostname)
host=${1:-$host}
gip=$(curl -s inet-ip.info)
echo "$gip $host $date"
