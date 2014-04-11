#!/bin/bash
#alias l
# Required packages: expect
# Required scripts: func.getpar, func.temp, db-list, db-trace
# Required tables: login (user,password,host,rcmd)
# Description: login command
. func.getpar
_usage "[host] (command)" <(db-list login)
sshopt="-o StrictHostKeyChecking=no -t"
host=$1;shift
eval "$(db-trace $host login)"
eval "$(db-trace $host host)"
eval "$(db-trace $auth auth)"
password=${password:+$(edit-crypt -d <<< "$password")}
[ "$1" ] && rcmd="$*"
if [ "$command" = telnet ]; then
    telnet $host
else
    . func.temp
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
