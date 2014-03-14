#!/bin/bash
#alias l
# Required packages: expect,bsdmainutils(column),sed
# Required scripts: func.usage, db-list, db-setfield, func.temp
# Required tables: login (user,password,host,rcmd)
# Description: login command
. func.usage "[host] (command)" < <(db-list login) $1
sshopt="-o StrictHostKeyChecking=no -t"
host=$1;shift
. db-setfield $host login
setfield $host host;shift
[ "$1" ] && rcmd="$*"
if [ "$command" = telnet ]; then
    telnet $host
else
    str="ssh $sshopt ${user:+$user@}$host"
    [ "$VER" ] && echo $str
    if [ "$password" ] ; then
        . func.temp expfile
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
