#!/bin/bash
# Description: process control
. func.msg
_retry(){ # Retry func until success with counter (<20) [func name]
    for (( i=0; i < 20; i++));do
        $* && return
        echo -n '.'
        sleep 1
    done
    return 1
}
_no_proc(){
    ! pidof $1 > /dev/null
}
_kill_proc(){ # Kill proc with counter [proc name]
    _no_proc $1 && return
    sudo killall $1
    _retry _no_proc $1 && echo "$1 was killed"
}
_chkfunc $*
