#!/bin/bash
#link rc.login
#link rc.logout
shopt -s nullglob
dorc(){
    log=~/.var/log/${0##*/}.log
    date > $log
    for i in $0.*;do
        source $i
    done >> $log 2>&1
}
dorc &
