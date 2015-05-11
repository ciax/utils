#!/bin/bash
# Required packages: openssh-server
# Required scripts: ssh-config
# Desctiption: setup ssh files 
# Usage: ${0##*/} (-r:remove keys)
. func.getpar
_warn "Initializing SSH"
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
cfg=~/.ssh/config
[ "$1" = -r ] && rm $sec $pub
type ssh > /dev/null || _abort "No ssh installed"
[ -e $sec ] || ssh-keygen
[ -e $pub ] || ssh-keygen -y -f $sec > $pub
[ -e $inv ] || touch $inv
[ -e $ath ] || cp $pub $ath
grep -q "$(< $pub)" $ath || cat $pub >> $ath
ssh-config > $cfg
