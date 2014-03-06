#!/bin/bash
# Required script: func.usage
# Required packages: coreutils(sort),openssh-client(ssh),iputils-ping(ping)
# Show list of the user@host which will accept ssh connection
. func.usage "[(user@)host ..]" $1
ahost=''
auser=''
chkcom(){
    ssh -q -o "BatchMode=yes" -o "ConnectTimeout=1" $1 : && auser="$auser $1"
}
for i ; do
    host="${i#*@}"
    if [[ $ahost =~ /$host/ ]]; then
        chkcom $i
    else
        chkcom $i && ahost="$ahost $host"
    fi
done
sort -u <<< $auser

