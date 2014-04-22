#!/bin/bash
# Required packages: openssh-server
# Required scripts: ssh-config
# Desctiption: setup ssh files 
# Usage: ${0##*/} (-r:remove keys)
. func.getpar
echo $C5"Initializing SSH"$C0
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
cfg=~/.ssh/config
ssh-config > $cfg
[ "$1" = -r ] && rm $sec $pub
type ssh > /dev/null || _abort "No ssh installed"
[ -e $sec ] || ssh-keygen
[ -e $pub ] || ssh-keygen -y -f $sec > $pub
[ -e $ath ] || touch $ath
[ -e $inv ] || touch $inv
