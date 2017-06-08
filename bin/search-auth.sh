#!/bin/bash
#alias auth
# Required packages: expect
# Required scripts: func.getpar db-trace crypt-de
# Required tables: auth
# Description: Get auth info
. func.getpar
show(){
    [[ "$password" == jA0EA* ]] && crypt-de || cat
}
_usage "[id]" $(db-list auth)
id=$1;shift
[ "$id" ] && eval "$(db-trace $id auth)"
crypt-init
password=$(echo $password | show)
mid=${password:1:-1}
ast=${mid//?/*}
_warn "Using Password (${password/$mid/$ast})"
echo $password
