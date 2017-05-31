#!/bin/bash
#alias vpng
# Required packages(Debian,Raspbian): openvpn
# Required scripts: func.getpar show-syslog
# Description: client for netgear router openvpn
. func.getpar
xopt-d(){ #disconnect
    pidof openvpn > /dev/null
    if [ $? -eq 0 ]; then
        sudo killall openvpn
        sleep 5
        echo "openvpn was killed"
    fi
}
wait_tun(){
    for (( i=0; i < 20; i++));do
        set - $(ifconfig |grep tun)
        if [[ $1 =~ tun ]]; then
            export TUN=$1
            echo "TUN interface is $TUN"
            sudo iptables -t nat -A POSTROUTING -o $TUN -j MASQUERADE
            return
        else
            echo -n '.'
            sleep 1
        fi
    done
    echo "Tun doesn't exist"
    xopt-d
    return 1
}
_usage "[vpnhost]" $( _basename_list ~/cfg.*/ngvpn/*.conf)
sel=$1
set - ~/cfg.*/ngvpn/$sel.conf
cd ${1%/*}
sudo openvpn --daemon --config $sel.conf --pull 2>/dev/null|tee -a ~/.var/ngvpn-$sel.log && wait_tun
