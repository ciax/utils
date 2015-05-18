#!/bin/bash
# Show UNIX like OS
# Linux/DIST,SunOS,BSD,Darwin(OSX)
case $(uname) in
    Linux)
        echo -n "Linux/"
        exp="Debian|Raspbian|Ubuntu|CentOS|QNAP"
        egrep -ho "$exp" /etc/*{release,issue}* /proc/version|head -1
        ;;
    *)
        uname
        ;;
esac
