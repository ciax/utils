#!/bin/bash
# Required script: ssh-setup, func.temp, edit-merge
# Required packages: coreutils(grep,cut,sort),diffutils(cmp),openssh-client(scp)
# Impose own trust to the object host (push pub-key anonymously)
#link ssh-join
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
[[ ${rhost#*@} =~ "`hostname`|localhost" ]] && abort "Self push"
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
. func.temp rtemp
case $0 in
    *ssh-push) 
	temp akeys
	cut -d' ' -f1-2 $lath > $akeys
	;;
    *ssh-join) akeys=$lath;;
    *) exit;;
esac
# Add to authorized_keys
addrem $rhost:$rath $akeys
# Add to invalid_keys
addrem $rhost:$rinv $linv
