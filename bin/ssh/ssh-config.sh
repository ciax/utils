#!/bin/bash
# Required scripts: ac.app, db-exec, net-name, db-trace
# Required tables: login(command,user,password,host),ssh(subnet,login,alias,port,proxy)
# Description: generate ~/.ssh/config
. func.app
site(){
    eval "$(db-trace $1 login)"
    [ "$command" = ssh ] || return
    sub=$(net-name)
    eval "$(db-trace src=$sub,dst=$id ssh)"
    [ ! "$password" ] || [ "$proxy" ] || return
    eval "$(db-trace $host host)"
    echo "Host $1"
    echo -e "\tHostName ${alias:-${fdqn:-$host}}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
}

net=$1;shift
for lid in $(db-list login);do
    (site $lid)
done
