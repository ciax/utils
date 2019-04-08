#!/bin/bash
shopt -s nullglob
dorc(){
    date
    for i in ~/bin/rc.logout.*;do
        source $i
    done
}
dorc > ~/.var/log/rc.logout.log
