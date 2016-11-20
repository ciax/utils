#!/bin/bash
# http://qiita.com/mt08/items/9f357be12c126d8976b3
# git clone https://github.com/mt08xx/vgc.git

OPT_DAEMON= #--daemon

VPNGATE_CONF=/etc/openvpn/vpngate.conf
USER_VPNGATE=/etc/openvpn/user_vpngate.txt
VPNGATE_CSV=~/.vpngate.csv
CMD=$1
CMD=${CMD,,} #lowercase
NUM=3

if [ ! -z $CMD ] ; then
    if [ $CMD == "update" ] ; then OPT_UPDATE=update ; fi
    if [ $CMD == "clean" ] ; then sudo rm $USER_VPNGATE $VPNGATE_CSV $VPNGATE_CONF; echo cleaned ; exit ; fi
    if [ $CMD -gt 0 ] ; then NUM=$(( $NUM + $CMD)); fi
fi


function create_userpassfile() {
    echo -e "vpn\nvpn" | sudo tee $USER_VPNGATE
    sudo chmod 700 $USER_VPNGATE
}

function download_vpngate_csv() {
    wget http://www.vpngate.net/api/iphone/ -O - | tail -n +$NUM | grep Japan > $VPNGATE_CSV
    return 0
}

mkconf(){
    cut -d ',' -f 15 | base64 -d | sed -e "s/#auth-user-pass/auth-user-pass\ \/${USER_VPNGATE//\//\\\/}/g" | sudo tee $VPNGATE_CONF > /dev/null
}

#
if [ -e $USER_VPNGATE ]; then
    echo found $USER_VPNGATE
else
    create_userpassfile
fi

pidof openvpn > /dev/null ; if [ $? -eq 0 ]; then sudo killall openvpn ; sleep 5; fi

download_vpngate_csv

# Show Server List
#cat $VPNGATE_CSV | cut -d ',' -f 1-10 | column -s, -t  | less -#2 -N -S

# Select Server
#echo -n "Enter #"
#read
# openvpn is running ???

sudo rm -f $VPNGATE_CONF
while read;do
    mkconf
    exec sudo openvpn --daemon --config $VPNGATE_CONF --connect-retry-max 1 && break
done < $VPNGATE_CSV
sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

