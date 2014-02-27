#!/bin/bash
[ "$1" ] || . set.usage "[file]"
base=$(basename $1)
body="${base%.*}"
core="${body#db-}"
echo ${core%-*}
