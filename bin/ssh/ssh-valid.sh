#!/bin/bash
# Required commands: ssh,ping
# Required scripts: func.app
# Description: show list of the user@host which will accept the ssh connection
. func.app
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

