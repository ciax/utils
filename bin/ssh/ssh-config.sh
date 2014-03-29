#!/bin/bash
# Description: generate ~/.ssh/config
# Required scripts: db-exec, net-name, db-setfield
# Required tables: login(command,user,password,host),ssh(subnet,login,alias,port,proxy)
. db-setfield
net=$1;shift
for lid in $(db-list login);do
    resetfield login ssh host
    setfield $lid login
    [ "$command" = ssh ] || continue
    sub=$(net-name)
    setfield src=$sub,dst=$id ssh
    [ ! "$password" ] || [ "$proxy" ] || continue
    setfield $host host
    echo "Host $lid"
    echo -e "\tHostName ${alias:-${fdqn:-$host}}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
done
