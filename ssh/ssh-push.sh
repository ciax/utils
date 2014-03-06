#!/bin/bash
# Required script: ssh-setup, func.temp, edit-merge
# Required packages: coreutils(grep,cut,sort),diffutils(cmp),openssh-client(scp)
# Impose own trust to the object host (push pub-key anonymously)
. func.usage "[(user@)host]" $1
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
. func.temp trem trath
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
