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
alist=~/.var/cache/arplist.txt
_usage
_exe_opt
eval "$(info-net)"
_msg "Scannig network ($cidr)"
nmap -n -sn $opt $cidr > /dev/null 2>&1
arp -n|grep -v incomplete | tee $alist
_msg "$alist was updated"
