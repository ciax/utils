#!/bin/bash
# Description: execute scripts at reboot
#link cron.daily
per=$1
PATH=~/bin:$PATH
file=mynet.$HOSTNAME.txt
log=~/.var/log/cron.reboot.log
echo "###### $(date) ######">$log
echo "## Set ##" >> $log
set >> $log
echo "## Env ##" >> $log
env >> $log
echo "## Exec ##" >> $log
update
cd ~/cfg.def/etc
info-net | tee $file >> $log
git add $file
git commit $file -m "Network interface was updated.($HOSTNAME)"
git push
