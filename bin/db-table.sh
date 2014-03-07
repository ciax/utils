#!/bin/bash
. func.usage "[file]" $1
base=$(basename $1)
body="${base%.*}"
core="${body#db-}"
echo ${core%-*}
