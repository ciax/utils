#!/bin/bash
case `uname` in
    Linux)
        set - $(< /etc/issue)
        case "$*" in
            *bian*)
                echo "debian-${3%.*}";;
            Ubuntu*)
                echo "ubuntu-${2%.*}";;
            CentOS*)
                echo "centos-${3%.*}";;
            White*)
                echo "redhat-${6%.*}";;
            *QNAP*)
		echo "qnap";;
            *);;
        esac;;
    SunOS)
        ver=$(uname -r)
        echo "sunos-${ver%.*}";;
    *);;
esac