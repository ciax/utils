#!/bin/bash
# Required scripts: ac.getpar db-exec net-name db-trace
# Required tables: ssh(host,user,auth,port,proxy)
# Description: generate ~/.ssh/config
#   For multiple forwarding on gsheet cell: "port adr:port,port adr:prt,..."
. func.getpar
# Set to $HOME/.ssh
xopt-s(){ #Write to ~/.ssh/config
    $0 | text-update
}
_usage
forward(){
    local IFS=:
    set - $1
    case $1 in
	L) echo -e "\tLocalForward $2 $3:$4";;
	R) echo -e "\tRemoteForward $2 $3:$4";;
    esac
}
site(){
    eval "$(db-trace $1 ssh)"
    eval "$(db-trace $auth auth)"
    [ "$password" -a ! "$proxy" ] && return
    eval "$(db-trace $host host)"
    echo "Host $1"
    [ "$proxy" ] && echo -e "\tProxyCommand ssh -W %h:%p $(search-ip $proxy)"
    if [ "$resolv" = "ddns" ]; then
        eval "$(db-trace $host ddns)"
        name=${fdqn:-$ip}
    else
        name="$(search-ip $host)"
    fi
    echo -e "\tHostName ${name:-$host}"
    echo -e "\tUser $user"
    [ "$port" ] && echo -e "\tPort $port"
    if [ "$forward" ]; then
	local IFS=,
	for i in $forward; do
	    forward $i
	done
        echo -e "\tGatewayPorts yes"
    fi
    echo
}

_title 'Generationg ssh config'
echo "#file $HOME/.ssh/config"
for sid in $(db-list ssh);do
    (site $sid)
done
echo "# General Setting"
echo "StrictHostKeyChecking no"
