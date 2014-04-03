#!/bin/bash
# Required commands: grep,tr,sort,sed
# Required scripts: func.app
# Description: show required something in comments
. func.app
_usage "[type]"
cd ~/utils
grep -ihr "^# *req.* $1" * | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|grep .|sort -u
