#!/bin/bash
shopt -s nullglob
log=~/.var/log/logout.log
for i in ~/bin/rc.logout.*;do
    source $i
done >$log 2>&1 &
