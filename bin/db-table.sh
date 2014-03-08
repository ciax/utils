#!/bin/bash
# Desctiption: pick up the table names from file name(db-*.csv)
# Required packages: coreutils(basename)
# Required scripts: func.usage
. func.usage "[file]" $1
base=$(basename $1)
body="${base%.*}"
core="${body#db-}"
echo ${core%-*}
