#!/bin/bash
# Required commands: netstat
shopt -s nullglob
eth=$(netstat -nr|egrep "^0\.0\.0\.0"|egrep -o "eth.*")
set - $(netstat -nr|egrep -o "^([12].+) +0\.0\.0\.0 +255\.255.*U .*$eth")
netif=$8
subnet=$1
netmask=$3
set - ${netmask//./ }
for i in ${subnet//./ };do
    bcast="$bcast$d$(( $i + 255 - $1 ))"
    d=.
    shift
done
echo "netif=$netif"
echo "subnet=$subnet"
echo "netmask=$netmask"
echo "bcast=$bcast"
