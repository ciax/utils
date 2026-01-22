#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: search IP addres by mac
#alias mac
. func.getpar
opt-r(){ #Refresh arp
    eval "$(info-net)"
    _msg "Scannig network ($subnet)"
    nmap -n -sn $subnet > /dev/null 2>&1
    arp -n|grep -v incomplete > $alist
}
opt-s(){ hset=1; } #Set to /etc/hosts
alist=~/.var/cache/arplist.txt
_usage "[host].."
_exe_opt
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
[ -f $alist ] || opt-r
_temp hlist hosts
while read ip type mac other ; do
    host=${hos[$mac]}
    echo "Find $ip for $host ($mac)" 1>&2
    echo "$ip    $host" >> $hlist
done < <(egrep -i "($mreg)" $alist)
# /etc/hosts rewreite
[ "$hset" ] || exit
egrep -v " ($hreg)$" /etc/hosts > $hosts
if [ -s $hlist ] ; then
    cat $hlist >> $hosts
    msg="Add to /etc/hosts"
else
    msg="Delete from /etc/hosts"
fi
_overwrite /etc/hosts $hosts || msg="No changes on /etc/hosts"
_msg "$msg"
