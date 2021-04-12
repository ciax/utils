#!/bin/bash
#[ "$1" ] || { echo "Usage:aws-esttime -(se)"; exit; }
. aws-conf
elap(){
    set - $(date -ud @$1 +"%j %R:%S")
    echo "$(( $1 -1 ))day $2"
}
start=$(stat -c %Z $dellist)
last=$(stat -c %Z $dellog)
(( elapsed=last-start ))
allsize=$(stat -c %s $dellist)
delsize=$(stat -c %s $dellog)
rate=$(echo "scale=5; $delsize/$elapsed" | bc)
remain=$(echo "scale=0; ($allsize - $delsize)/$rate" | bc)
(( finish=last+remain ))
echo -n "Start time: "
date -ud @$start
echo -n "Last updated: "
date -ud @$last
echo -n "Elapsed time: "
elap $elapsed
echo "Processing rate(byte/s): $rate"
echo -n "Estimated remaining time: "
elap $remain
echo -n "Estimated date of finish: "
date -ud @$finish

