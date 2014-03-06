#!/bin/bash
# Required script: set.usage
# Required packages: coreutils(sort),openssh-client(ssh),iputils-ping(ping)
# Show list of the user@host which will accept ssh connection
. set.usage "[(user@)host ..]" $1
ahost=''
auser=''
chkcom(){
    ssh -q -o "BatchMode=yes" $1 : && auser="$auser $1"
}
for i ; do
    host="${i#*@}"
    if [[ $ahost =~ /$host/ ]]; then
        chkcom $i
    elif ping -c1 -w1 $host &>/dev/null; then
        ahost="$ahost $host"
        chkcom $i
    fi
done
echo $auser|sort -u

