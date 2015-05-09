#!/bin/bash
# Required scripts: ac.getpar db-exec net-name db-trace
# Required tables: ssh(host,user,auth,port,proxy)
# Description: generate ~/.ssh/config
. func.getpar
site(){
    eval "$(db-trace $1 ssh)"
    [ ! "$password" ] || [ "$proxy" ] || return
    eval "$(db-trace $host host)"
    ip="$(search-ip $host)"
    echo "Host $1"
    echo -e "\tHostName ${ip:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
}

echo "#$HOME/.ssh/config"
for sid in $(db-list ssh);do
    (site $sid)
done
