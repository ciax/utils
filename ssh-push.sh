#!/bin/bash
# Required script: ssh-setup.sh, set.tempfile.sh, edit-merge.sh
# Required command: scp,grep,cut,sort,cmp
# Impose own trust to the object host (push pub-key anonymously)
[ "$1" ] || { echo "Usage: ${0##*/} [(user@)host]"; exit; }
rhost=$1
ssh-setup
if [ "$LOGNAME" = ${rhost%@*} ]; then
    [ ${rhost#*@} = `hostname` ] && { echo "Self push"; exit 1; }
    [ ${rhost#*@} = 'localhost' ] && { echo "Self push"; exit 1; }
fi
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
. set.tempfile trem trath
scp -pq $rhost:$rath $trem
{ grep @ $trem;cut -d' ' -f1-2 $lath; }|sort -u > $trath
if ! cmp -s $trem $trath; then
    scp -pq $trath $rhost:$rath
    echo "authorized_keys is updated at $rhost"
fi
scp -pq $rhost:$rinv $trem
edit-merge $trem $linv
if ! cmp -s $trem $linv ; then
    scp -pq $linv $rhost:$rinv
    echo "invalid_keys is updated at $rhost"
fi
