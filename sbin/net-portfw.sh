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
_usage "[port] [dstip] (dstport)"

pf1=

pf1="_sudy iptables -t nat -A PREROUTING -i eth0 --dport $1 -j DNAT --to-destination $2:${3:-$1}"
pf2="_sudy iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"

echo $pf1
echo $pf2
