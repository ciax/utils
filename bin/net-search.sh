#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.getpar
xopt-r(){ #Refresh arp
    eval "$(info-net)"
    _msg "Scannig network ($cidr)"
    nmap -sn $cidr > /dev/null 2>&1
    arp -n|grep -v incomplete > $alist
}
opt-s(){ #Set to /etc/hosts
    egrep -v " ($hreg)$" /etc/hosts > $hosts
    if [ -s $hlist ] ; then
	cat $hlist >> $hosts
	msg="Add to /etc/hosts"
    else
	msg="Delete from /etc/hosts"
    fi
    _overwrite /etc/hosts < $hosts || msg="No changes on /etc/hosts"
    _msg "$msg"
}
alist=~/.var/arplist.txt
_usage "[host].."
declare -A hos
for host ; do
    mac=$(search-mac $host)
    if [ "$mac" ] ; then
        hos[${mac,,}]=$host
        mreg="$mreg${mreg:+|}$mac"
        hreg="$hreg${hreg:+|}$host"
    else
        _alert "No such host $host"
    fi
done
[ "$hreg" ] || exit 1
[ -f $alist ] || xopt-r
_temp hlist hosts
while read ip type mac other ; do
    host=${hos[$mac]}
    echo "Find $ip for $host ($mac)" >/dev/stderr
    echo "$ip    $host" >> $hlist 
done < <(egrep -i "($mreg)" $alist)
_exe_opt
