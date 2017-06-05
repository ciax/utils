#!/bin/bash
#alias vpng
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar func.proc show-syslog
# Description: client for netgear router openvpn
. func.getpar
. func.proc
chk_tun(){
    set - $(ifconfig |grep tun)
    [[ $1 =~ tun ]] || return 1
    export TUN=$1
    sudo iptables -t nat -A POSTROUTING -o $TUN -j MASQUERADE
}
exe_vpn(){
    set - ~/cfg.*/ngvpn/$sel.conf
    cd ${1%/*}
    sudo openvpn --daemon --config $sel.conf --pull 2>/dev/null|tee -a ~/.var/ngvpn-$sel.log || return 1
    if _retry chk_tun ; then
        echo "TUN interface is $TUN"
    else
        echo "TUN doesn't exist"
        _kill_proc openvpn
        return 1
    fi
}
xopt-d(){
    _kill_proc openvpn
}
_usage "[vpnhost]" $( _basename_list ~/cfg.*/ngvpn/*.conf)
sel=$1
_kill_proc openvpn
exe_vpn
