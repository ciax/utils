#!/bin/bash
# Description: show required something in comments
# Required packages: coreutils(grep,tr,sort),sed
# Required scripts: func.usage
. func.usage "[type]" $1
cd ~/utils
grep -ihr "^# *req.* $1" * | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|sort -u
