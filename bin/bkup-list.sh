#!/bin/bash
#alias bl
# Required scripts: func.getpar bkup-exec
# Descripton: display backed up files
. func.getpar
list(){
    where="where host == '$(hostname)' and dist == '$(info-dist)'"
    bkup-exec "select dir,name,count(*) from list $where group by name;"|tr , ' '
}
opt-b(){ #bare output
    list;exit
}
[ "$(bkup-exec .tables)" ] || bkup-init
_usage
while read dir name count;do
    echo -e "$name [$dir] ($count)"
done < <(list)|column -t