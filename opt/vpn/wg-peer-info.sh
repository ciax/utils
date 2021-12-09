#!/bin/bash
#alias wgp
# Required packages: wireguard
# Required scripts: func.getpar
# Description: Print Own Peer Information
#
# Internal IP Assignment
#  Server: 10.0.(subnet).254
#  Client: 10.0.(server subnet).n (n=1..253)
. func.getpar
xopt-s(){ # Save to Config Dir
    $0 | text-update
    cd ~/etc
    git add wg_peer.$HOSTNAME.txt
    git commit -m 'Update wg peer info'
    git push
}
# Shared Procedures
mkkeys(){
    [ "$1" ] || { echo "No prv file setting"; return; }
    privkey=$1
    if [ ! -e $privkey ]; then
	wg genkey > $privkey
	chmod 600 $privkey
	echo "$privkey was generated"
    fi
    pubkey=$(wg pubkey < $privkey)
}
getinfo(){
    set - $(ip -br addr|grep UP)
    itf=$1
    loa=${3%/*}
    lom=${3#*/}
    los=${3%.*}
    v6a=${4%/*}
    v6m=${4#/*}
    v4a="$(curl -s inet-ip.info)"
    sub=$(( (${los//./+}) % 128))
    tunaddr="10.0.$sub.254"
}
prpar(){
    echo "#file $HOME/etc/wg_peer.$HOSTNAME.txt"
    echo "wg_host=$HOSTNAME"
    echo "wg_pub=$pubkey"
    echo "wg_tun=$tunaddr"
    echo "wg_loc=$loa"
    echo "wg_sub=$los.0/$lom"
    echo "wg_ipv4=$v4a"
    echo "wg_ipv6=$v6a"
}
# Making Working Directory
mkdir -p ~/.var/wg
mkdir -p -m 700 ~/.wg
cd ~/.wg
_usage
# Making Config Files
mkkeys privkey
getinfo
prpar
