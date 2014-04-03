#!/bin/bash
#alias l
# Required commands: expect,column,sed,ssh,(telnet)
# Required scripts: func.app, db-list, db-trace
# Required tables: login (user,password,host,rcmd)
# Description: login command
. func.app
_usage "[host] (command)" $(db-list login)
sshopt="-o StrictHostKeyChecking=no -t"
host=$1;shift
eval "$(db-trace $host login)"
eval "$(db-trace $host host)"
[ "$1" ] && rcmd="$*"
if [ "$command" = telnet ]; then
    telnet $host
else
    str="ssh $sshopt ${user:+$user@}$host"
    [ "$VER" ] && echo $str
    if [ "$password" ] ; then
        _temp expfile
        echo "set timeout 10" > $expfile
        echo "spawn -noecho $str" >> $expfile
        echo "expect word: { send $password\n };" >> $expfile
        [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
        echo "interact" >> $expfile
        expect $expfile
    else
        $str $rcmd
    fi
fi
