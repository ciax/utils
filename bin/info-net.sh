#!/bin/bash
# Required commands: netstat
shopt -s nullglob
mask2cidr(){
    local x=${1##*255.}
    set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
    x=${1%%$3*}
    echo $(( $2 + (${#x}/4) ))
}
broadcast(){
    local sub=$1;shift
    set - ${1//./ }
    for i in ${sub//./ };do
        bcast="$bcast$d$(( $i + 255 - $1 ))"
        d=.;shift
    done
    echo $bcast
}
eth=$(netstat -nr|egrep "^0\.0\.0\.0"|egrep -o "eth.*")
set - $(netstat -nr|egrep -o "^([12].+) +0\.0\.0\.0 +255\.255.*U .*$eth")
netif=$8
subnet=$1
netmask=$3
cidr="$subnet/$(mask2cidr $netmask)"
bcast="$(broadcast $subnet $netmask)"
echo "netif=$netif"
echo "subnet=$subnet"
echo "netmask=$netmask"
echo "bcast=$bcast"
echo "cidr=$cidr"
