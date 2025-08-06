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
    _sudy iptables -t nat -vL
}
_usage "[port] [dstip] (dstport)"

pf1="iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $1 -j DNAT --to-destination $2:${3:-$1}"
pf2="iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

_sudy $pf1
_sudy $pf2
_sudy iptables -t nat -L
