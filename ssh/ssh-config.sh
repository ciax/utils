#!/bin/bash
# generate ~/.ssh/config
net=${1:-$(net-name)}
for lid in $(db-register "select id from login where command == 'ssh';");do
    . set.field "'$lid'" login
    num=$(db-register "select id from ssh where subnet == '$net' and login == '$id';")
    . set.field "'${num:-0}'" ssh
    [ ! "$password" ] || [ "$proxy" ] || continue
    echo "Host $lid"
    echo -e "\tHostName ${alias:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
done
