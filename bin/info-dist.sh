#!/bin/bash
case `uname` in
    Linux)
        set - $(< /etc/issue)
        case $1 in
            Debian*)
                echo "debian-${3%.*}";;
            Ubuntu*)
                echo "ubuntu-${2%.*}";;
            White*)
                echo "redhat-${6%.*}";;
            *);;
        esac;;
    SunOS)
        ver=$(uname -r)
        echo "sunos-${ver%.*}";;
    *);;
esac