#!/bin/bash
# Description: Debian package utils
# Required packages: sudo,apt-spy,debconf,findutils
# Required scripts: func.usage
. func.usage "[type]" $1
cd ~/utils
grep -ihr "^# *req.* $1" * | tr -d ' ' | sed -re 's/\([^\)]+\)//g' -e 's/.*://'| tr ',' '\n'|sort -u
