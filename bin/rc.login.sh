#!/bin/bash
# $0 will be -bash at login
shopt -s nullglob
dorc(){
    local i log=~/.var/log/rc.$1.log 2>&1
    date > $log
    for i in ~/bin/rc.$1.*;do
        nohup $i >> $log &
    done
}
dorc login
