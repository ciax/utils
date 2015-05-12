#!/bin/bash
# Required scripts: func.getpar func.ssh
# Desctiption: share authorized keys with remote host (Accepts join)
. func.getpar
. func.ssh
getrem(){
    scp $sshopt -pq ${port:+-P $port} $rhost:$1 $2
}
putrem(){
    cmp -s $1 $2 && return
    scp $sshopt -pq ${port:+-P $port} $1 $rhost:$3
    echo "${3##*/}($(stat -c%s $1)) is updated at $rhost"
}
_usage "[(user@)host(:port)] .."
#setup-ssh
sshopt="-o StrictHostKeyChecking=no"
ath=.ssh/authorized_keys
inv=.ssh/invalid_keys
lath=~/$ath
linv=~/$inv
_temp rath rinv tath tinv
for url;do
    IFS=:; set - $url; unset IFS
    rhost=$1; port=$2
    [[ "$rhost" =~ (`hostname`|localhost) ]] && _abort "Self push"
    echo "Host $rhost${port:+:$port}"
# Get files from remote
    getrem $ath $rath
    getrem $inv $rinv
# Join with local file
    cat $rath $lath > $tath
    cat $rinv $linv > $tinv
# Trimming
    _ssh-mark $tath
    _auth-trim $tath $tinv >/dev/null
# Put files back to remote
    putrem $tath $rath $ath
    putrem $tinv $rinv $inv
# Renew local files
    _overwrite $lath < $tath
    _overwrite $linv < $tinv
done
