#!/bin/bash
#alias bkl
# Required scripts: bkup-exec
# Descripton: display backed up files
[ "$(bkup-exec .tables)" ] || bkup-init
IFS=,;read name count < <(bkup-exec "select name,count(*) from list group by name;")
echo "$name ($count)"
