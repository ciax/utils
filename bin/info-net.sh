#!/bin/bash
# Required commands: netstat
#alias mynet
shopt -s nullglob
eth=$(netstat -nr|egrep "^0\.0\.0\.0"|egrep -o "eth.*")
set - $(netstat -nr|egrep -o "^([12].+) +0\.0\.0\.0 +255\.255.*U .*$eth")
echo "netif=$8"
sub=$1
mask=$3
set - ${mask//./ }
for i in ${sub//./ };do
    bc="$bc$d$(( $i + 255 - $1 ))"
    d=.
    shift
done
echo "subnet=$sub"
echo "netmask=$mask"
echo "bcast=$bc"
