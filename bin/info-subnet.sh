#!/bin/bash
# Required commands: netstat
shopt -s nullglob
netstat -nr|egrep -o "^([12].+) +0\.0\.0\.0 +255\.255.*eth"|cut -d' ' -f1
