#!/bin/bash
# Description: generate ~/.ssh/config
# Required scripts: db-register, net-name, db-setfield
# Required tables: login(command,user,password,host),ssh(subnet,login,alias,port,proxy)
. db-setfield
net=$1;shift
for lid in $(db-register "select id from login where command == 'ssh';");do
    setfield $lid login
    [ "$id" ] || continue
    sub=$(net-name)
    db-register "select"
    [ "$num" ] || continue
    setfield ${num:-0} ssh
    [ ! "$password" ] || [ "$proxy" ] || continue
    echo "Host $lid"
    echo -e "\tHostName ${alias:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
done
