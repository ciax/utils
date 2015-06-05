#!/bin/bash
# Required scripts: func.getpar
# Description: execute scripts which is listed in cfg.*/etc/$HOSTNAME.period.cron
# Usage: cron-exec [daily|weekly]
. func.getpar
_usage "[period]" hourly daily weekly
per=$1
cmd=cron.$per.$HOSTNAME
type -t $cmd >/dev/null 2>&1 || exit
log=~/.var/cron.$per.log
date > $log
$cmd 2>&1 | tee -a $log 
