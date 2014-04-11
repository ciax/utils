#!/bin/bash
#alias bl
# Required scripts: bkup-exec
# Descripton: display backed up files
[ "$(bkup-exec .tables)" ] || bkup-init
IFS=,
while read name count;do
    echo "$name ($count)"
done < <(bkup-exec "select name,count(*) from list group by name;")
