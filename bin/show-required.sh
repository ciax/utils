#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
. func.getpar
_usage "[type]"
egrep -ih "^# *re.* $1(\(.*,?$DIST,?.*\)|):" ~/bin/*|tr -d '*' |\
 while read line;do
    for i in ${line#*:};do
        echo ${i%(*}
    done
done | sort -u
