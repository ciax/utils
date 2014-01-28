#!/bin/bash
shopt -s nullglob
set - `netstat -nr|grep -v tun|egrep '^0.0.0.0'`
echo ${2%.*}
