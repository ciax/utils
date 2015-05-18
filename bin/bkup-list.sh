#!/bin/bash
#alias bl
# Required scripts: func.getpar bkup-exec
# Descripton: display backed up files
. func.getpar
_list(){
    where="where host == '$(hostname)' and dist == '$(info-dist)'"
    bkup-exec "select dir,name,count(*) from list $where group by name;"
}
xopt-b(){ #bare output
    _list
}
[ "$(bkup-exec .tables)" ] || bkup-init
_usage
_exe_opt
_list | { IFS=\|; while read d n c;do
    echo "$n   [$d]   ($c)"
done }
