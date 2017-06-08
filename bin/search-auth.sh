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
echo $password | show
