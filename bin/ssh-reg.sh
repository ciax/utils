#!/bin/bash
# Required packages: openssh-server
# Required scripts: ssh-config
# Description: register ssh pugkey
# Usage: ${0##*/} (-r:remove keys)
. func.getpar
. func.ssh
_title "Registering SSH Keys"
[ "$1" = -r ] && rm -f $SEC $PUB
_ssh_setup
cd ~/etc/ssh || exit
cp $PUB $USER.$HOSTNAME.pub
git add .
git commit -m "Update: ssh pubkey;" && git push
# Additional
egrep -h '^ssh-rsa ' *.pub >> $LATH
_ssh_auth_trim
cut -d' ' -f 1,2 $LATH > $LATH.pub
