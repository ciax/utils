#!/bin/bash
# Required scripts: rc.app
# Required packages: coreutils(sort),openssh-client(ssh),iputils-ping(ping)
# Description: show list of the user@host which will accept the ssh connection
. rc.app
_usage "[(user@)host ..]"
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

