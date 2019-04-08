#!/bin/bash
# $0 will be -bash at login
shopt -s nullglob
dorc(){
    date
    for i in ~/bin/rc.login.*;do
        source $i
    done
}
dorc > ~/.var/log/rc.login.log
