#!/bin/bash
# Description: generate ~/.ssh/config
# Required scripts: db-register, db-sshid, db-setfield
# Required tables: login(command,user,password,host),ssh(alias,port,proxy)
net=$1
for lid in $(db-register "select id from login where command == 'ssh';");do
    . db-setfield $lid login
    num=$(db-sshid $id)
    . db-setfield ${num:-0} ssh
    [ ! "$password" ] || [ "$proxy" ] || continue
    echo "Host $lid"
    echo -e "\tHostName ${alias:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
done
