#!/bin/bash
#alias vpng
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar func.proc show-syslog
# Description: client for netgear router openvpn
. func.getpar
. func.proc
xopt-d(){ #disconnect
    act=$(ifconfig|grep ^tun) || return
    set - $act
    sudo iptables -t nat -D POSTROUTING -o $1 -j MASQUERADE
    _wait_kill openvpn
}
exe_vpn(){
    set - ~/cfg.*/ngvpn/$sel.conf
    cd ${1%/*}
    sudo openvpn --daemon --config $sel.conf --pull 2>/dev/null|tee -a ~/.var/ngvpn-$sel.log || return 1
    if _wait_if tun ; then
        export TUNGW=${IFADDR%.*}.1
        sudo iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
    else
        xopt-d
        return 1
    fi
}
_usage "[vpnhost]" $( _basename_list ~/cfg.*/ngvpn/*.conf)
sel=$1
xopt-d
exe_vpn
