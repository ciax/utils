#!/bin/bash
#alias vpng
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar func.proc show-syslog
# Description: client for netgear router openvpn
. func.getpar
. func.proc
xopt-d(){
    sudo iptables -t nat -F
    sudo iptables -F
    _wait_kill openvpn
}
set_nat(){
    set - $(ifconfig $INTERFACE|grep 'inet addr')
    addr=${2#*:}
    sudo iptables -A INPUT -i tun+ -j ACCEPT
    sudo iptables -A FORWARD -i tun+ -j ACCEPT
    sudo iptables -A FORWARD -i tun+ -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i br0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -t nat -A POSTROUTING -s ${addr%.*}.0/24 -o br0 -j MASQUERADE
    sudo iptables -A OUTPUT -o tun+ -j ACCEPT
}
exe_vpn(){
    set - ~/cfg.*/ngvpn/$sel.conf
    cd ${1%/*}
    sudo openvpn --daemon --config $sel.conf --pull 2>/dev/null|tee -a ~/.var/ngvpn-$sel.log || return 1
    if _wait_if tun ; then
        set_nat
    else
        xopt-d
        return 1
    fi
}
_usage "[vpnhost]" $( _basename_list ~/cfg.*/ngvpn/*.conf)
sel=$1
xopt-d
exe_vpn
