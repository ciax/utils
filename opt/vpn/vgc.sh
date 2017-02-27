#!/bin/bash
# http://qiita.com/mt08/items/9f357be12c126d8976b3
# git clone https://github.com/mt08xx/vgc.git

OPT_DAEMON= #--daemon

VPNGATE_CONF=/etc/openvpn/vpngate.conf
USER_VPNGATE=/etc/openvpn/user_vpngate.txt
VPNGATE_CSV=~/.vpngate.csv
CMD=$1
CMD=${CMD,,} #lowercase
NUM=1

if [ ! -z $CMD ] ; then
    if [ $CMD == "update" ] ; then OPT_UPDATE=update ; fi
    if [ $CMD == "clean" ] ; then sudo rm $USER_VPNGATE $VPNGATE_CSV $VPNGATE_CONF; echo cleaned ; exit ; fi
    if [ $CMD -gt 0 ] ; then
        NUM=$CMD
        echo "Takes $NUM lines or later"
    fi
fi


function create_userpassfile() {
    echo -e "vpn\nvpn" | sudo tee $USER_VPNGATE
    sudo chmod 700 $USER_VPNGATE
}

function download_vpngate_csv() {
    wget http://www.vpngate.net/api/iphone/ -O - > $VPNGATE_CSV
    return 0
}

mkconf(){
    grep Japan $VPNGATE_CSV | sed -n ${NUM}p | cut -d ',' -f 15 | base64 -d | sed -e "s/#auth-user-pass/auth-user-pass\ ${USER_VPNGATE//\//\\\/}/g" | sudo tee $VPNGATE_CONF > /dev/null
}
kilvpn(){
    pidof openvpn > /dev/null
    if [ $? -eq 0 ]; then
        sudo killall openvpn
        sleep 5
    fi
}

#
if [ -e $USER_VPNGATE ]; then
    echo found $USER_VPNGATE
else
    create_userpassfile
fi

kilvpn

[ -s $VPNGATE_CSV -a $NUM -gt 1 ] || download_vpngate_csv

# Show Server List
#cat $VPNGATE_CSV | cut -d ',' -f 1-10 | column -s, -t  | less -#2 -N -S

# Select Server
#echo -n "Enter #"
#read
# openvpn is running ???

mkconf
grep remote $VPNGATE_CONF
sudo openvpn --daemon --config $VPNGATE_CONF --connect-retry-max 1 || exit
for (( i=0; i < 10; i++));do
    set - $(ifconfig |grep tun)
    if [[ $1 =~ tun ]]; then
        export TUN=$1
        echo "TUN interface is $TUN"
        sudo iptables -t nat -A POSTROUTING -o $TUN -j MASQUERADE
        exit
    else
        echo -n '.'
        sleep 1
    fi
done
echo "Tun doesn't exist"
kilvpn
exit 1
