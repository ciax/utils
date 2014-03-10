#!/bin/bash
# Description: login command
# Required packages: expect,bsdmainutils(column),sed
# Required scripts: func.usage, db-list, db-setfield, db-sshid, func.temp
# Required tables: login (user,password,host,rcmd)
#alias l
. func.usage "[host]" < <(db-list login) $1
sshopt="-o StrictHostKeyChecking=no -t"
. db-setfield $1 login
[ "$(db-sshid)" ] && host=
if [ "$host" ]; then
    shift
    str="${command//ssh/ssh $sshopt} -l $user $host $*"
else
    str="ssh $sshopt $*"
fi

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
