#!/bin/bash
# Required scripts: func.getpar
# Description: Print crontab setting for cfg.*/etc/cron.(interval).$HOSTNAME
#              Option (-t) gives one minutes later crontab for testing.
# Usage: cron-setup (-t) [hourly|daily|weekly]
# Specific schedule can be described in the cron file
#   Format: #crontab:0 0 0 0 0
. func.getpar
opt-t(){ # Test mode (exec two munites later)
    m=$(( $(date +%M) + 1 ))
    df='*'
}
list=""
m=$(date +%S)
_exe_opt
_temp crontab
if [ -e ~/bin/cron-reboot ]; then
    echo "@reboot $HOME/bin/cron-reboot" >> $crontab
fi
for per in hourly daily weekly $1; do
    [ -e ~/bin/cron.$per ] || [ -e ~/bin/cron.$per.$HOSTNAME ] || continue
    #Override schedule by comment in the file
    sch="$(grep crontab ~/bin/cron.$per*|cut -d: -f3)"
    case $per in
        hourly) def="$m * * * *";;
        daily) def="$m 17 * * *";;
        weekly) def="$m 5 * * 1";;
        *) def="* * * * *";;
    esac
    echo "${sch:-$def} $HOME/bin/cron-exec $per" >> $crontab
done
[ -s $crontab ] || exit
echo 'MAILTO=""'
echo "PATH=$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin"
cat $crontab
