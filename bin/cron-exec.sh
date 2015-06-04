#!/bin/bash
# Required scripts: func.getpar
# Description: execute scripts which is listed in cfg.*/etc/$HOSTNAME.period.cron
# Usage: cron-exec [daily|weekly]
. func.getpar
_usage "[period]" <<< $'hourly\ndaily\nweekly'
per=$1
log=~/cron.$per.log
file=cron.$per.$HOSTNAME
case "$per" in
    hourly) ;;
    daily) ;;
    weekly) ;;
    *) _abort "No such period";;
esac
date >> $log
type -t $file >/dev/null 2>&1 || { echo "No exec file" |tee -a $log; exit 1; }
$file >> $log 2>&1
