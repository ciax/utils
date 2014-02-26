#!/bin/bash
# Required Packages: expect,bsdmainutils(column),sed
# Required DB:db-debice/login (!id,command,tunnel,user,password,host,rcmd)
#alias lo
getstr(){
    db-device ' ' <<< "select command,user,host from login where id = '$1';"|sed -e 's/ssh/ssh -o StrictHostKeyChecking=no/g'
}
list(){
    db-device <<< 'select id from login;'|sort|column -c60
}
[ "$1" ] || . set.usage "[host]" < <(list)
id=$1;shift
str="$(getstr $id) $*"
tun=$(db-device <<< "select tunnel from login where id == '$id';")
[ "$tun" ] && str="$(getstr $tun) $str"
pass=$(db-device <<< "select password from login where id == '$id';")
rcmd=$(db-device <<< "select rcmd from login where id == '$id';")
if [ "$pass" ] ; then
    . set.tempfile expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho $str" >> $expfile
    echo "expect word: { send $pass\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
else
    $str $rcmd
fi
