#!/bin/bash
# Required scripts: ac.getpar db-exec net-name db-trace
# Required tables: ssh(host,user,auth,port,proxy)
# Description: generate ~/.ssh/config
. func.getpar
# Set to $HOME/.ssh
xopt-s(){ $0 | cfg-install; }
_usage
site(){
    eval "$(db-trace $1 ssh)"
    [ "$auth" -o "$proxy" ] && return
    eval "$(db-trace $host host)"
    echo "Host $1"
    if [ "$resolv" = "ddns" ]; then
        name=$(db-exec "select fdqn from ddns where host='$host';"|head -1)
    else
        name="$(search-ip $host)"
    fi
    echo -e "\tHostName ${name:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $proxy"
}

echo "#file $HOME/.ssh/config"
echo "StrictHostKeyChecking no"
for sid in $(db-list ssh);do
    (site $sid)
done
