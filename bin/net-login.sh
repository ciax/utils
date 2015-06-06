#!/bin/bash
#alias l
# Required packages: expect
# Required scripts: func.getpar db-list db-trace
# Required tables: login(user,password,host,rcmd)
# Description: login command
. func.getpar
_usage "[host] (command)"
id=$1;shift
if egrep -q "Host $id$" ~/.ssh/config; then
    _warn "Found in sshconfig"
    ssh $id
    exit
fi
sshopt="-o StrictHostKeyChecking=no -t"
eval "$(db-trace $id ssh)"
eval "$(db-trace $id host)"
[ "$auth" ] && eval "$(db-trace $auth auth)"
crypt-init
[[ "$password" == jA0EA* ]] && password=$(crypt-de <<< "$password")
[ "$1" ] && rcmd="$*"
if [ "$host" ]; then
    _warn "Found in DB"
    batch="-o BatchMode=yes"
    [ "$port" ] && sshopt="$sshopt -p $port"
    ssharg="$sshopt ${user:+$user@}$host"
    [ "$VER" ] && echo "ssh $ssharg $rcmd"
    echo "ssh $batch $ssharg $rcmd"
    ssh $batch $ssharg $rcmd && exit
    _temp expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho ssh $ssharg" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
elif usr=$(cut -d' ' -f3 ~/.ssh/authorized_keys|tr , $'\n'|grep "@$id$"); then
    _warn "Found in Authrizedkeys"
    ssh $usr
else
    _warn "telnet $id"
    telnet $id
fi
