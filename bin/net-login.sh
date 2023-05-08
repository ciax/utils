#!/bin/bash
#alias l
# Required packages: expect net-tools
# Required scripts: func.getpar db-list db-trace
# Required tables: login(user,password,host,rcmd)
# Description: login command
. func.getpar
# Basic function
mk_ssharg(){
    local sshopt="-o StrictHostKeyChecking=no -t"
    local dst="${user:+$user@}$host"
    _warn "Found in DB [$dst]"
    [ "$port" ] && { sshopt="$sshopt -p $port"; dst="$dst"; }
    ssharg="$sshopt $dst"
}
decrypt_pw(){
    [[ "$password" == jA0E* ]] || return
    crypt-init
    password=$(echo "$password" | crypt-de)
    # Mask like 'x***y'
    local mid=${password:1:-1}
    local ast=${mid//?/*}
    _warn "Using Password (${password/$mid/$ast})"
}
# SSH login by cases
by_config(){
    local sshlist=$(egrep -A2 "^Host $id$" ~/.ssh/config)
    [ "$sshlist" ] || return
#    [[ $sshlist =~ Proxy ]] && return
    _warn "Found in sshconfig"
    while read a b
    do
        # Remove following entry
        [[ $a =~ Host ]] && ! [[ $b =~ $id ]] && break
        _item "$a,$b\n"
    done < <(egrep -A5 "Host $id$" ~/.ssh/config)
    echo
    ssh $id $command
    exit
}
by_db(){
    eval "$(db-trace $id ssh)"
    eval "$(db-trace $id host)"
    if [ "$resolv" = 'ddns' ]
    then
        eval "$(db-trace $id ddns)"
        host="${ip:-$fdqn}"
    fi
    [ "$host" ] || return
    [ "$command" ] && rcmd+=";$command"
    # $id will be changed due to getting auth
    eval "$(db-trace $auth auth)"
    mk_ssharg
    by_pubkey
    by_password
}
by_pubkey(){
    _warn "Try pubkey_auth"
    local batch="-o BatchMode=yes"
    echo "ssh $batch $ssharg '$rcmd'"
    ssh $batch $ssharg "$rcmd" && exit
}
# For SSH password login
by_password(){
    _warn "Try password_auth"
    decrypt_pw
    _temp expfile
    echo "set timeout 10" > $expfile
    echo "spawn -noecho ssh $ssharg" >> $expfile
    echo "expect word: { send $password\n };" >> $expfile
    [ "$rcmd" ] && echo "expect -re \".+ \"  { send \"$rcmd\n\" }" >> $expfile
    echo "interact" >> $expfile
    expect $expfile
    exit
}
# For trust site
by_trust(){
    dst=$(cut -d' ' -f3 ~/.ssh/authorized_keys|tr , $'\n'|grep "@$id$") || return
    _warn "Found in Authrizedkeys [$dst]"
    ssh $dst $command
    exit
}
# For host which has specific login command file
by_script(){
    type "login-$id" || return
    login-$id $command
    exit
}
by_telnet(){
    _warn "telnet $id"
    telnet $id
}

_usage "[host] (command)" $(db-list ssh)
id=$1
shift
command=$*
by_config
by_db
by_trust
by_script
by_telnet
