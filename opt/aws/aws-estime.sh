#!/bin/bash
#Required packages: bc
#alias estime
. aws-conf
now=$(date +%s)
start=$(stat -c %Y $delarc)
last=$(stat -c %Y $dellog)
(( elapsed=last-start ))
allsize=$(stat -c %s $dellist)
delsize=$(stat -c %s $dellog)
((allfiles=allsize/139))
((delfiles=delsize/139))
((percent=delfiles*100/allfiles))
ptime=$(echo "scale=5; $elapsed/$delfiles" | bc)
remain=$(printf "%.0f" $(echo "($allfiles-$delfiles)*$ptime"|bc))
(( finish=last+remain ))
# Status
echo -n " Status : "
(( now > last + 5 )) && echo "Stopping" || echo "Running" 
echo
# Time Info
echo -n " Start time   : "
date -d @$start
echo -n " Last updated : "
date -d @$last
echo -n " Elapsed time : "
elap $elapsed
echo
# For comma separated number
LC_NUMERIC=en_US.utf8
# File processing info
printf " Total Files   : %'d\n" $allfiles
printf " Deleted Files : %'d\n" $delfiles
printf " Percentage    : %'d%%\n" $percent
echo " Processing time(sec/file): $ptime"
echo
# Time estimation
echo -n " Estimated remaining time : "
elap $remain
echo -n " Estimated date of finish : "
date -d @$finish

