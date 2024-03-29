#!/bin/bash
# Required scripts: func.getpar
# Description: Print crontab setting for cfg.*/etc/cron.(interval).$HOSTNAME
#              Option (-t) gives two minutes later crontab for testing.
# Usage: cron-setup (-t) [hourly|daily|weekly]
. func.getpar
opt-t(){ # Test mode (exec two munites later)
    m=$(( $(date +%M) + 2 ))
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
echo "PATH=$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin"
cat $crontab
