#!/bin/bash
# Required script: set.usage.sh
# Require command: head,grep,tr
# make insert sentence for sql from *.csv or db-*.tsv file
[ -e "$1" ] || . set.usage "[file]"
body=${1%.*}
core=${body#*db-}
table=${core%-*}
pfx="insert or ignore into $table values ("
while read line; do
    list="'${line//,/','}'"
    null="${list//\'\'/null}"
    echo "$pfx$null);"
done < <(egrep -v '^([#!].*|[[:blank:]]*)$' $*|nkf -Lu|tr $'\t' ',')
