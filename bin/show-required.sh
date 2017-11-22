#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
# Format: "# Required [type]s: item1 item2 ...
. func.getpar
_usage "[type]" $( egrep -oh "^# *Required [^:(]+" *|cut -d' ' -f 3|sort -u)
egrep -ih "^# *re.* $1(\(.*,?$DIST,?.*\)|):" ~/bin/*|tr -d '*' |\
 while read line;do
    for i in ${line#*:};do
        echo ${i%(*}
    done
done | sort -u
