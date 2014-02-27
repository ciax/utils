#!/bin/bash
# Required Packages: expect,bsdmainutils(column),sed
# Required DB:db-debice/login (!id,command,tunnel,user,password,host,rcmd)
#alias lo
getstr(){
    . set.field login $1;shift
    str="${command//ssh/ssh $sshopt} $user $host $*"
}
list(){
    db-device <<< 'select id from login;'|sort|column -c60
}
[ "$1" ] || . set.usage "[host]" < <(list)
sshopt="-o StrictHostKeyChecking=no -t -l"
getstr $1

[ "$tunnel" ] && str="$(getstr $tunnel;echo $str) $str"
if [ "$password" ] ; then
    . set.tempfile expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho $str" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
else
    $str $rcmd
fi
