#!/bin/bash
# Required scripts: func.getpar db-trace crypt-de
# Required tables: auth
# Description: Get auth info
. func.msg
_show_pw(){
    [[ "$password" == jA0EA* ]] && crypt-de || cat

}
_auth(){ # Set $user and $password
    id=$1;shift
    [ "$id" ] && eval "$(db-trace $id auth)"
    crypt-init
    password=$(echo $password | _show_pw)
    mid=${password:1:-1}
    ast=${mid//?/*}
    _warn "Using Password (${password/$mid/$ast})"
}
_chkfunc $*
