#!/bin/bash
# Required scripts: func.usage, net-name, db-register
# Required tables: ssh(subnet,login)
# Generate ~/.ssh/config
. func.usage "[host]" $1
[ "$net" ] || net=$(net-name)
db-register "select id from ssh where subnet == '$net' and login == '$1';"
