#!/bin/bash
# Description: execute scripts which is listed in cfg.*/etc/cron.period.$HOSTNAME
[ "$1" ] || { echo "Usage: cron-exec [hourly|daily|weekly]"; exit; }
per=$1
cmd=cron.$per.$HOSTNAME
type -t $cmd >/dev/null 2>&1 || exit
log=~/.var/cron.$per.log
echo "###### $(date) ######">$log
echo "## Set ##" >> $log
set >> $log
echo "## Env ##" >> $log
env >> $log
echo "## Exec ##" >> $log
$cmd 2>&1 | tee -a $log 
