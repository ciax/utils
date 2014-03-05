#!/bin/bash
# Required Packages: expect,bsdmainutils(column),sed
# Required DB:db-debice/login (!id,command,tunnel,user,password,host,rcmd)
#alias l
[ "$1" ] || . set.usage "[host]" < <(db-list login)
sshopt="-o StrictHostKeyChecking=no -t -l"
. set.field "'$1' and command == 'ssh'" login
if [ "$host" ]; then
    shift
    str="${command//ssh/ssh $sshopt} $user $host $*"
else
    str="ssh $sshopt $*"
fi

if [ "$password" ] ; then
    . set.tempfile expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho $str" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
else
echo    $str $rcmd
fi
