#!/bin/bash
# Description: execute scripts which is listed in cfg.*/etc/cron.period.$HOSTNAME
[ "$1" ] || { echo "Usage: cron-exec [hourly|daily|weekly|etc.]"; exit; }
per=$1
PATH=~/bin:$PATH
log=~/.var/log/cron.$per.log
echo "###### $(date) ######">$log
echo "## Set ##" >> $log
set >> $log
echo "## Env ##" >> $log
env >> $log
echo "## Exec ##" >> $log
for n in $per $per.$HOSTNAME; do
    type -t cron.$n >/dev/null 2>&1 || continue
    cron.$n >> $log 2>&1
done
