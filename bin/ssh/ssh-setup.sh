#!/bin/bash
# Required scripts: func.temp.sh, ssh-trim.sh
# Required packages: coreutils(grep,cut,cat,sort),diffutils(cmp),openssh-client(ssh,ssh-keygen)
# Usage: ${0##*/} (-r:remove keys)
ath=~/.ssh/authorized_keys
inv=~/.ssh/invalid_keys
sec=~/.ssh/id_rsa
pub=~/.ssh/id_rsa.pub
cfg=~/.ssh/config
[ "$1" = -r ] && rm $sec $pub
type ssh > /dev/null || apt-get install ssh
[ -e $sec ] || ssh-keygen
[ -e $pub ] || ssh-keygen -y -f $sec > $pub
[ -e $ath ] || touch $ath
[ -e $inv ] || touch $inv
[ -e $cfg ] || ssh-config > $cfg
ssh-trim
