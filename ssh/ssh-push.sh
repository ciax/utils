#!/bin/bash
# Required script: ssh-setup, func.temp, edit-merge
# Required packages: coreutils(grep,cut,sort),diffutils(cmp),openssh-client(scp)
# Impose own trust to the object host (push pub-key anonymously)
addrem(){
    local rfile=$1;shift
    local ltemp=$1;shift
    scp -pq $rfile $rtemp
    edit-merge $ltemp $rtemp >/dev/null
    cmp -s $rtemp $ltemp && return
    scp -pq $ltemp $rfile
    echo "${rfile##*/} is updated at $rhost"
}
. func.usage "[(user@)host]" $1
rhost=$1
ssh-setup
if [ "$LOGNAME" = ${rhost%@*} ]; then
    [ ${rhost#*@} = `hostname` ] && abort "Self push"
    [ ${rhost#*@} = 'localhost' ] && abort "Self push"
fi
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
. func.temp rtemp pushkeys
cut -d' ' -f1-2 $lath > pushkeys
# Add to authorized_keys
addrem $rhost:$rath $pushkeys
# Add to invalid_keys
addrem $rhost:$rinv $linv
