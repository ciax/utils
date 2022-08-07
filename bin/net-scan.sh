#!/bin/bash
# Required packages: nmap
# Required scripts: search-mac info-net
# Description: Scan Localnet
#alias scl
. func.getpar
xopt-r(){ #Clear arp
    for i in $(arp |grep ether| cut -d' ' -f1);do
        sudo arp -d $i
    done
}
opt-u(){ #Udp Scan
    opt="-PU"
}
opt-s(){ #Syn Scan
    opt="-PS"
}
opt-a(){ #Ack Scan
    opt="-PA"
}
_view(){
    local brand m_n description
    eval $(db-trace $1 mac device model | grep -v "/")
    echo -e "$1\t$2\t$brand $m_n\t\t$description"
}
alist=~/.var/cache/arplist.txt
settmp=~/.var/temp.txt
_usage
_exe_opt
eval "$(info-net)"
_msg "Scannig network ($cidr)"
nmap -n -sn $opt $cidr > /dev/null 2>&1
arp -n|grep ether | while read a b c d; do
    _view ${c^^} $a
done | sort | tee $alist
_msg "$alist was updated"
