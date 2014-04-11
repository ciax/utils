#!/bin/bash
#alias bl
# Required scripts: bkup-exec
# Descripton: display backed up files
[ "$(bkup-exec .tables)" ] || bkup-init
IFS=,
while read dir name count;do
    echo -e "$name [$dir] ($count)"
done < <(bkup-exec "select dir,name,count(*) from list group by name;")|column -t
