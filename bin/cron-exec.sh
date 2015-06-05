#!/bin/bash
# Required scripts: func.getpar
# Description: execute scripts which is listed in cfg.*/etc/$HOSTNAME.period.cron
# Usage: cron-exec [daily|weekly]
. func.getpar
_usage "[period]" hourly daily weekly
per=$1
log=~/.var/cron.$per.log
cmd=cron.$per.$HOSTNAME
date >> $log
type -t $cmd >/dev/null 2>&1 || { _alert "No exec file" |tee -a $log; exit 1; }
$cmd >> $log 2>&1
