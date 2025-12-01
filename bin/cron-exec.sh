#!/bin/bash
# Description: execute scripts which is listed in bin/cron.(interval).$HOSTNAME
[ "$1" ] || { echo "Usage: cron-exec [hourly|daily|weekly|reboot|etc.]"; exit; }
per=$1
PATH=~/bin:$PATH
source ~/bin/rc.bash
# Recording Environment
log=~/.var/log/cron.env.log
echo "###### $(date) ######">$log
echo "## Set ##" >> $log
set >> $log
echo "## Env ##" >> $log
env >> $log
# Recording Execution Log
log=~/.var/log/cron.$per
cat $log.log >> $log.$(date +%Y).log
echo -e "\n\n###### $(date) ######">$log.log
for n in ~/bin/cron.$per ~/bin/cron.$per.$HOSTNAME; do
    type -t $n >/dev/null 2>&1 || continue
    $n >> $log.log 2>&1
done
