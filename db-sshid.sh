#!/bin/bash
# generate ~/.ssh/config
[ "$1" ] || . set.usage "[host]"
[ "$net" ] || net=$(net-name)
db-register "select id from ssh where subnet == '$net' and login == '$1';"
