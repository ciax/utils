#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
. func.getpar
_usage "[type]"
while read line;do
    for i in ${line#*:};do
        echo ${i%(*}
    done
done < <(egrep -ih "^# *req.* $1(\(.*,?$DIST,?.*\)|):" ~/bin/*|tr -d '*')|sort -u
