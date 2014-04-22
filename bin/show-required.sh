#!/bin/bash
# Required commands: sed
# Required scripts: func.getpar
# Description: show required something in comments
. func.getpar
_usage "[type]"
egrep -ihr "^# *req.* $1(\($DIST\)|):" ~/*/ | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|grep .|sort -u
