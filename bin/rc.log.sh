#!/bin/bash
# Log (in/out) boot strap
shopt -s nullglob
log=~/.var/log/rc.log$1.log
date > $log
for i in ~/bin/rc.log$1.*;do
    source $i
done >> $log  2>&1
cat $log
