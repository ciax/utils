#!/bin/bash
. set.usage "[file]" $1
base=$(basename $1)
body="${base%.*}"
core="${body#db-}"
echo ${core%-*}
