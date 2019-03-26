#!/bin/bash
shopt -s nullglob
log=~/.var/log/login.log
date > $log
for i in ~/bin/rc.login.*;do
    source $i
done >> $log 2>&1 &
