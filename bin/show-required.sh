#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
. func.getpar
_usage "[type]"
egrep -ih "^# *req.* $1(\($DIST\)|):" ~/bin/* | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|grep .|sort -u
