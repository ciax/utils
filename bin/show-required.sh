#!/bin/bash
# Required packages: coreutils(grep,tr,sort),sed
# Required scripts: rc.app
# Description: show required something in comments
. rc.app
_usage "[type]" $1
cd ~/utils
grep -ihr "^# *req.* $1" * | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|sort -u
