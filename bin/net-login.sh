#!/bin/bash
# Required packages: expect,bsdmainutils(column),sed
# Required DB:db-debice/login (!id,command,tunnel,user,password,host,rcmd)
#alias l
. func.usage "[host]" < <(db-list login) $1
sshopt="-o StrictHostKeyChecking=no -t"
. set.field "'$1' and command in ('ssh','telnet')" login
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
