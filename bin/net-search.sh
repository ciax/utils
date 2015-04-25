#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.temp
xopt-r(){ #Refresh arp
    eval "$(info-net)"
    echo "Scannig network ($cidr)"
    nmap -sn $cidr > /dev/null 2>&1
    arp -n|grep -v incomplete > $alist
}
opt-s(){ #Set to /etc/hosts
    egrep -v " ($hreg)$" /etc/hosts > $hosts
    cat $hlist >> $hosts
    _overwrite $hosts /etc/hosts
    echo "Set to /etc/hosts"
}
alist=~/.var/arplist.txt
_usage "[host].."
declare -A hos
for host ; do
    mac=$(search-mac $host)
    if [ "$mac" ] ; then
        hos[$mac]=$host
        mreg="$mreg${mreg:+|}$mac"
        hreg="$hreg${hreg:+|}$host"
    else
        echo "No such host $host"
    fi
done
[ "$hreg" ] || exit 1
[ -f $alist ] || xopt-r
_temp hlist hosts
while read ip type mac other ; do
    host=${hos[$mac]}
    echo "Find $ip for $host ($mac)"
    echo "$ip    $host" >> $hlist 
done < <(egrep -i "($mreg)" $alist)
_exe_opt
