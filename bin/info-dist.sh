#!/bin/bash
case `uname` in
    Linux)
        set - $(< /etc/issue)
        case $1 in
            *bian*)
                echo "debian-${3%.*}";;
            Ubuntu*)
                echo "ubuntu-${2%.*}";;
            CentOS*)
                echo "centos-${3%.*}";;
            White*)
                echo "redhat-${6%.*}";;
            *);;
        esac;;
    SunOS)
        ver=$(uname -r)
        echo "sunos-${ver%.*}";;
    *);;
esac