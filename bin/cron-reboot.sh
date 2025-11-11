#!/bin/bash
# Description: execute scripts at reboot
#alias cron.daily
per=$1
PATH=~/bin:$PATH
file=mynet.$HOSTNAME.txt
log=~/.var/log/${0##*/}.log
echo -e "\n\n###### $(date) ######" >>$log
git-pullall
db-update
cd ~/etc
info-net | tee $file >> $log
git add $file
git commit $file -m "Network interface was updated.($HOSTNAME)"
git push
cron-exec reboot
