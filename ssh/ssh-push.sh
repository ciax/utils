#!/bin/bash
# Required script: ssh-setup, ssh-trim, func.temp, edit-merge
# Required packages: coreutils(grep,cut,sort),diffutils(cmp),openssh-client(scp)
# Impose own trust to the object host (push pub-key anonymously)
#link ssh-join
getrem(){
    scp -pq $rhost:$1 $2
    cp $2 $3
}
putrem(){
    cmp -s $1 $2 && return
    scp -pq $1 $rhost:$3
    echo "${3##*/}($(stat -c%s $1)) is updated at $rhost"
}
. func.usage "[(user@)host]" $1
rhost=$1
ssh-setup
[[ ${rhost#*@} =~ "`hostname`|localhost" ]] && abort "Self push"
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
. func.temp trath trinv tath tinv
# Get files from remote
getrem $rath $trath $tath
getrem $rinv $trinv $tinv
# Trimming
case $0 in
    *ssh-push)
	cut -d' ' -f1-2 $lath >> $tath
	;;
    *ssh-join)
	cat $lath >> $tath; join=1
	;;
    *)
	exit
	;;
esac
cat $linv >> $tinv
ssh-trim $tath $tinv >/dev/null
# Put files back to remote
putrem $tath $trath $rath
putrem $tinv $trinv $rinv
# Renew local files
[ "$join" ] && overwrite $tath $lath
overwrite $tinv $linv
