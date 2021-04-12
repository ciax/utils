#!/bin/bash
#[ "$1" ] || { echo "Usage:aws-esttime -(se)"; exit; }
. aws-conf
start=$(stat -c %Z $dellist)
last=$(stat -c %Z $dellog)
(( elapsed=last-start ))
allsize=$(stat -c %s $dellist)
delsize=$(stat -c %s $dellog)
((allfiles=allsize/139))
((delfiles=delsize/139))
ptime=$(echo "scale=5; $elapsed/$delfiles" | bc)
remain=$(printf "%.0f" $(echo "($allfiles-$delfiles)*$ptime"|bc))
(( finish=last+remain ))

# Display
echo -n " Start time   : "
date -ud @$start
echo -n " Last updated : "
date -ud @$last
echo -n " Elapsed time : "
elap $elapsed
echo
# For comma separated number
LC_NUMERIC=en_US.utf8
printf " Total Files   : %'d\n" $allfiles
printf " Deleted Files : %'d\n" $delfiles
echo " Processing time(sec/file): $ptime"
echo
echo -n " Estimated remaining time : "
elap $remain
echo -n " Estimated date of finish : "
date -ud @$finish

