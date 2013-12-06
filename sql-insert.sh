#!/bin/bash
# Required script: set.usage.sh
# Require command: head,grep,tr
# make insert sentence for sql from db-*.tsv file
[ -e "$1" ] || . set.usage "[file]"
body=${1%.*}
core=${body#*db-}
table=${core%-*}
dlm=$'\t'
key=${idx%%$dlm*}
fld=
echo "begin;"
pfx="insert or ignore into $table values ('"
while read i ; do
    echo "$pfx${i//$'\t'/','}');"
done < <(grep -h '.' $*|grep -v '^[#!]')
echo "commit;"
