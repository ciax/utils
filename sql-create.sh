#!/bin/bash
# Required script: set.usage.sh
# Require command: head,grep,tr
# Create table for sql from db-*.tsv file
[ -e "$1" ] || . set.usage "[file]"
body=${1%.*}
core=${body##*-}
table=${core%-*}
idx=$(grep '^!' $1|head -1|tr -d '!')
dlm=$'\t'
key=${idx%%$dlm*}
fld=${idx//$dlm/"','"}
echo "create table $table ('$fld',primary key('$key'));"
