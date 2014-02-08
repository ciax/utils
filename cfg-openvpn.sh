#!/bin/bash
# Client for dd-wrt openvpn server
commoncfg(){
    cat<<EOF
script-security 2
verb 3
comp-lzo
keepalive 15 60
management localhost 7505
proto udp
dev tun
daemon
ca $keydir/ca.crt
EOF
}
clientcfg(){
  commoncfg
  cat<<EOF
cert $keydir/$host.crt
key $keydir/$host.key
client
tls-client
remote $rhost 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ns-cert-type server
route 172.16.$ch.0 255.255.255.0
status /var/log/openvpn-status.log
EOF
  [ "$proxy" ] && cat <<EOF
http-proxy-retry
http-proxy $proxy
EOF
}

servercfg(){
  commoncfg
  cat<<EOF
cert $keydir/server.crt
key $keydir/server.key
dh $keydir/dh1024.pem
port 1194
tls-server
ifconfig 10.0.$ch.1 10.0.$ch.2
EOF
}

[ "$1" ] || . set.usage "[server|host(coqui/sansho/oyabi)]"
keydir=$HOME/.var
host=`hostname`
case $1 in
    server) servercfg;exit;;
    coqui)  ch=1;clientcfg;;
    sansho) ch=2;proxy="proxy 3128";clientcfg;;
    oyabi)  ch=3;clientcfg;;
    *);;
esac
