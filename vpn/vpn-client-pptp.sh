#!/bin/bash
#alias pptp
[ "$1" = "-r" ] && { sudo kill $(< /var/run/ppp0.pid); exit; }
[ "$1" ] || . set.usage "(-r:remove) [vpnhost]" < <(db-list vpn)
. set.field vpn $1
. set.tempfile temp
tail -4 $0 > $temp
sudo install $temp /etc/ppp/ip-up.d/route
id="--create $1"
host="--server $host"
user="--username $user"
[ "$password" ] && pw="--password $password"
opt="--encrypt"
sudo pptpsetup $id $host $user $pw $opt --start
exit

#ip-up params: interface-name tty-device speed local-IP-address remote-IP-address ipparam
#!/bin/sh
ifname=$1
rnet=${5%.*}.0
route add -net $rnet netmask 255.255.255.0 $ifname
