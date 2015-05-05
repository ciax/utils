#!/bin/bash
#Show Linux Distribusions grouping by packaging system
#Supported Dist: Debian,Raspbian,Ubuntu,CentOS,WhiteBox,QNAP(busybox+optware)
#Packaging system
# Optware (Qnap)
# Apt (Raspbian,Debian,Mint ...)
# Yum (CentOS,WhiteBox,RedHat ...)
# Pkg (SunOS)
# Appstore (Darwin)
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
