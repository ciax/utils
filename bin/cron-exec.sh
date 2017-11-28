#!/bin/bash
# Description: execute scripts which is listed in cfg.*/etc/cron.period.$HOSTNAME
[ "$1" ] || { echo "Usage: cron-exec [hourly|daily|weekly|etc.]"; exit; }
per=$1
PATH=~/bin:$PATH
cmd=cron.$per.$HOSTNAME
log=~/.var/log/cron.$per.log
echo "###### $(date) ######">$log
echo "## Set ##" >> $log
set >> $log
echo "## Env ##" >> $log
env >> $log
echo "## Exec ##" >> $log
if type -t $cmd >/dev/null 2>&1 ; then
    $cmd >> $log 2>&1
else
    echo "No such command $cmd" >> $log
fi
