#!/bin/bash
# Show UNIX like OS
# Linux/DIST,SunOS,BSD,Darwin(OSX)
case $(uname) in
    Linux)
        echo -n "Linux/"
        eval $(< /etc/os-release)
        echo ${NAME% *}
        ;;
    *)
        uname
        ;;
esac
