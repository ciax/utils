#!/bin/bash
# Description: control process/interface
. func.msg
_retry(){ # Retry func until success with counter (<20) [func name]
    for (( i=0; i < 20; i++));do
        $* && return
        echo -n '.'
        sleep 1
    done
    return 1
}
_no_proc(){ # True if no procs
    ! pidof $1 > /dev/null
}
_wait_kill(){ # ll proc with counter [proc name]
    _no_proc $1 && return
    killall $1
    _retry _no_proc $1 && echo "$1 was killed"
}
_get_if(){ # True if interface exists. $INTERFACE will be set
    act=$(ifconfig |egrep -A 2 "^$1") || return 1
    set - $act
    export INTERFACE=$1
    export IFADDR=${7#*:}
}
_wait_if(){ # Wait until $INTERFACE appears [if name]
    if _retry _get_if $1 ; then
        echo "${1^^} interface is $INTERFACE"
    else
        echo "${1^^} doesn't exist"
        return 1
    fi
}
_chkfunc $*
