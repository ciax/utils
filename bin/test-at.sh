#!/bin/bash
# Required scripts: func.getpar
# Description: Test 'at' command at nearest future (next minutes)
#    output > at.out
#alias atn
. func.getpar
_usage "[commands]"
_temp temp
tty=$(tty)
cat <<EOF > $temp
#!/bin/sh
$* > at.out 2>&1 
rm -f $temp
echo 'done' > $tty
EOF
now=$(date +%s)
later=$(( 60 - ( $now % 60 ) ))
next_min=$(( $now + $later ))
next_time=$(date -d@$next_min +%H:%M)
at $next_time -f $temp
echo "$later sec later"
