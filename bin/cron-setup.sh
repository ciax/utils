#!/bin/bash
# Required scripts: func.getpar
# Description: execute scripts which is listed in cfg.*/etc/$HOSTNAME.period.cron
# Usage: cron-exec [daily|weekly]
. func.getpar
opt-t(){ # Test mode (exec two munites later)
    m=$(( $(date +%M) + 2 ))
    df='*'
} 
list=""
m=$(date +%S)
_exe_opt
_temp crontab
for per in hourly daily weekly $1; do
    [ -e ~/bin/cron.$per.$HOSTNAME ] || continue
    case $per in
        hourly);;
        daily) h=${df:-3};;
        weekly) h=${df:-4};w=${df:-0};;
        *);;
    esac
    echo "$m ${h:-*} * * ${w:-*} $HOME/bin/cron-exec $per" >> $crontab
done
[ -s $crontab ] || exit
echo 'MAILTO=""'
echo "PATH=$HOME/bin:/usr/bin:/bin"
cat $crontab
