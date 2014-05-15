#!/bin/bash
# Required scripts: func.getpar func.temp  setup-ssh ssh-mark ssh-trim
# Desctiption: impose self trust to the object host (push pub-key anonymously)
. func.getpar
getrem(){
    scp $sshopt -pq $rhost:$1 $2
}
putrem(){
    cmp -s $1 $2 && return
    scp $sshopt -pq $1 $rhost:$3 && echo "${3##*/}($(stat -c%s $1)) is updated at $rhost"
}
_usage "[(user@)host] .."
setup-ssh
sshopt="-o StrictHostKeyChecking=no"
ath=.ssh/authorized_keys
lath=~/$ath
inv=.ssh/invalid_keys
linv=~/$inv
. func.temp
_temp rath rinv tath tinv
for rhost;do
    [[ ${rhost#*@} =~ "`hostname`|localhost" ]] && _abort "Self push"
    echo "Host:$rhost"
# Get files from remote
    getrem $ath $rath
    getrem $inv $rinv
# Join with local file
    cat $rath > $tath
    cut -d' ' -f1-2 $lath >> $tath
    cat $rinv $linv > $tinv
# Trimming
    ssh-mark $tath
    ssh-trim $tath $tinv >/dev/null
# Put files back to remote
    putrem $tath $rath $ath
    putrem $tinv $rinv $inv
# Renew local files
    _overwrite $tinv $linv
done
