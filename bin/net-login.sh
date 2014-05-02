#!/bin/bash
#alias l
# Required packages: expect
# Required scripts: func.getpar func.temp db-list db-trace
# Required tables: login(user,password,host,rcmd)
# Description: login command
. func.getpar
_usage "[host] (command)"
sshopt="-o StrictHostKeyChecking=no -t"
host=$1;shift
eval "$(db-trace $host login)"
eval "$(db-trace $host host)"
[ "$auth" ] && eval "$(db-trace $auth auth)"
crypt-init
[ "$password" ] && password=$(crypt-de <<< "$password")
[ "$1" ] && rcmd="$*"
if [ "$command" = telnet ]; then
    telnet $host
else
    . func.temp
    batch="-o BatchMode=yes"
    ssharg="$sshopt ${user:+$user@}$host"
    [ "$VER" ] && echo "ssh $ssharg $rcmd"
    ssh $batch $ssharg $rcmd && exit
    _temp expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho ssh $ssharg" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
fi
