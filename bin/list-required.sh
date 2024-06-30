#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
# Format: "# Required(Dist,Dist,...) [type]s: item1 item2 ...
#   Item lists are restricted to the distributions in brackets that follow behind.
#alias req
. func.getpar
_usage "[type]" $( egrep -oh "^# *Required [^:(]+" ~/bin/* | cut -d' ' -f 3 | sort -u)
while read line;do
    for i in ${line#*:};do
        echo "${i%(*}"
    done
done < <(egrep -ih "^# *re.* $1(\(.*,?$DIST,?.*\)|):" ~/bin/* | tr -d '*') | sort -u
