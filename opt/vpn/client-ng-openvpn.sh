#!/bin/bash
#alias vpng
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar show-syslog
# Description: client for netgear router openvpn
. func.getpar
retry(){
    for (( i=0; i < 20; i++));do
        $* && return
        echo -n '.'
        sleep 1
    done
    return 1
}
no_proc(){
    ! pidof $1 > /dev/null
}
kill_proc(){
    no_proc $1 && return
    sudo killall $1
    retry no_proc $1 && echo "$1 was killed"
}
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
    if retry chk_tun ; then
        echo "TUN interface is $TUN"
    else
        echo "TUN doesn't exist"
        kill_proc openvpn
        return 1
    fi
}
xopt-d(){
    kill_proc openvpn
}
_usage "[vpnhost]" $( _basename_list ~/cfg.*/ngvpn/*.conf)
sel=$1
kill_proc openvpn
exe_vpn
