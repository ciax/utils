#!/bin/bash
#alias pf
# Required packages(Debian,Raspbian,Ubuntu): iptables-persistent
# Required scripts: func.getpar 
# Description: port forwarding with iptables
# Usage: net-portfw [port] [ip:port] 
. func.sudo
xopt-s(){ # save setting mode
    _sudy netfilter-persistent save
}
xopt-c(){ # clear setting
    _sudy iptables -t nat -F
}
xopt-l(){ # list tables
    _sudy iptables -t nat -L PREROUTING -n -v
    _sudy iptables -t nat -L POSTROUTING -n -v
}
_usage "[ip] (port)  (localport)"

prexe(){
    echo "$*"
    _sudy "$*"
}

ip=$(info-host $1)
ip=${ip:-$1}
lp=${2:-80}
dp=${3:-$lp}

pf1="iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $lp -j DNAT --to-destination $ip:$dp"
pf2="iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

prexe $pf1 && prexe $pf2 && xopt-l
