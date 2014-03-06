#!/bin/bash
# generate ~/.ssh/config
. func.usage "[host]" $1
[ "$net" ] || net=$(net-name)
db-register "select id from ssh where subnet == '$net' and login == '$1';"
