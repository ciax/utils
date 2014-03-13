#!/bin/bash
#alias l
# Required packages: expect,bsdmainutils(column),sed
# Required scripts: func.usage, db-list, db-setfield, db-sshid, func.temp
# Required tables: login (user,password,host,rcmd)
# Description: login command
. func.usage "[host]" < <(db-list login) $1
host=$1;shift
sshopt="-o StrictHostKeyChecking=no -t"
. db-setfield $host login
setfield $host host
str="ssh $sshopt ${user:+$user@}$host $*"
echo $str
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
