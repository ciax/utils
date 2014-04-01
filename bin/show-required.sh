#!/bin/bash
# Required packages: coreutils(grep,tr,sort),sed
# Required scripts: src.app
# Description: show required something in comments
. src.app
_usage "[type]"
cd ~/utils
grep -ihr "^# *req.* $1" * | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|sort -u
