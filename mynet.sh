#!/bin/bash
shopt -s nullglob
set - `netstat -nr|grep -v tun|egrep '^0.0.0.0'`
net=${2%.*}
echo "select domain from subnet where id == '$net';"|sqlite3 ~/.var/db-device.sq3
