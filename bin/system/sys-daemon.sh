#!/bin/bash
# Required scripts: func.getpar
# Description: run daemon
. func.getpar
# functions
try(){
    local f="$1"
    local c=$2
    while [ $c -gt 0 ];do
        echo -n '.'
        sleep 1
        eval $f && { echo;return; }
        c=$(($c-1))
    done
    _abort "Timeout"
    return 1
}
wait_up(){ try "($check >/dev/null)" $1; }
wait_down(){ try "!($check >/dev/null)" $1; }
# options
opt-r(){ msg="Restart";kill=1; } #restart
opt-k(){ msg="Kill";kill=1;exit='exit'; } #kill
opt-t(){ tag=$1; } #=tag:set tag
# main
_usage "[cmd]"
_exe_opt
type $1 >/dev/null 2>&1 || _abort "No such command [$1]"
cd $(dirname $1)
line="setsid $* </dev/null 2>&1 "
logging="setsid logger -p user.err -t '${tag:=$line}' >/dev/null"
check="ps -eo pid,args|egrep -v 'grep|$0'|grep '$line\$'"
exe="cd /;setsid $line | $logging & wait_up 2"
echo "Process ($line) $msg"
while read pid cmd ; do
    if [ "$kill" ] ; then
        if kill $pid ; then
            [ "$exit" ] && { echo "  Killed"; exit; }
            echo -n "  Stopping "
            wait_down 3
        else
            _abort "  Faild to Kill"
        fi
    else
        _abort "  Already exists"
    fi
done < <(eval $check)
$exit
echo -n "  Starting "
try "($exe)" 3
git tag -afm "[$tag] at $(hostname) / $(date)" "run@$(date +%y%m%d)" >/dev/null 2>&1
