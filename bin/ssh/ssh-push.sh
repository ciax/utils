#!/bin/bash
#link ssh-join
# Required packages: coreutils(grep,cut,sort),diffutils(cmp),openssh-client(scp)
# Required scripts: rc.app, ssh-setup, ssh-trim, edit-merge
# Desctiption: impose own trust to the object host (push pub-key anonymously)
. rc.app
getrem(){
    scp -pq $rhost:$1 $2
    cp $2 $3
}
putrem(){
    cmp -s $1 $2 && return
    scp -pq $1 $rhost:$3
    echo "${3##*/}($(stat -c%s $1)) is updated at $rhost"
}
_usage "[(user@)host] .."
ssh-setup
case $0 in
    *ssh-push) cmd(){ cut -d' ' -f1-2; };;
    *ssh-join) cmd(){ cat; }; join=1 ;;
    *) exit ;;
esac
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
_temp trath trinv tath tinv
for rhost;do
    [[ ${rhost#*@} =~ "`hostname`|localhost" ]] && _abort "Self push"
    echo "Host:$rhost"
# Get files from remote
    getrem $rath $trath $tath
    getrem $rinv $trinv $tinv
# Join with local file
    cmd < $lath >> $tath
    cat $linv >> $tinv
# Trimming
    ssh-mark
    ssh-trim $tath $tinv >/dev/null
# Put files back to remote
    putrem $tath $trath $rath
    putrem $tinv $trinv $rinv
# Renew local files
    [ "$join" ] && _overwrite $tath $lath
    _overwrite $tinv $linv
done
