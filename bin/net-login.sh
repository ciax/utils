#!/bin/bash
#alias l
# Required packages: expect net-tools
# Required scripts: func.getpar db-list db-trace
# Required tables: login(user,password,host,rcmd)
# Description: login command
. func.getpar
_usage "[host] (command)"
id=$1;shift
sshlist=$(egrep -A2 "^Host $id$" ~/.ssh/config)
if [ "$sshlist" ] && [[ ! $sshlist =~ Proxy ]]; then
    _warn "Found in sshconfig"
    _msg $(egrep -A3 "Host $id$" ~/.ssh/config|grep -v "Host ")
    ssh $id
    exit
fi
sshopt="-o StrictHostKeyChecking=no -t"
eval "$(db-trace $id ssh)"
eval "$(db-trace $id host)"
eval "$(db-trace $auth auth)"
crypt-init
[ "$1" ] && rcmd="$*"
if [ "$host" ]; then
    # For SSH password login
    _warn "Found in DB"
    batch="-o BatchMode=yes"
    uri="${user:+$user@}$host"
    ssharg="$sshopt $uri"
    [ "$port" ] && { sshopt="$sshopt -p $port"; uri="$uri:$port"; }
    [ "$VER" ] && echo "ssh $batch $ssharg $rcmd"
    _msg "$uri"
    ssh $batch $ssharg $rcmd && exit
    _temp expfile
    if [[ "$password" == jA0EA* ]]; then
        password=$(crypt-de <<< "$password")
        mid=${password:1:-1}
        ast=${mid//?/*}
        _warn "Using Password (${password/$mid/$ast})"
    fi
    echo "set timeout 10" > $expfile
    echo "spawn -noecho ssh $ssharg" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
elif usr=$(cut -d' ' -f3 ~/.ssh/authorized_keys|tr , $'\n'|grep "@$id$"); then
    # For SSH public key login
    _warn "Found in Authrizedkeys"
    ssh $usr
elif type "login-$id"; then
    # For host which has specific login command file
    login-$id
else
    _warn "telnet $id"
    telnet $id
fi
