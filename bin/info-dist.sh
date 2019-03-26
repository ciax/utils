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
        eval $(< /etc/os-release)
        name=${NAME% *}
        ver=${VERSION% *}
        echo "${name,,}-${ver%.*}"
    ;;
    SunOS)
        ver=$(uname -r)
        echo "sunos-${ver%.*}"
    ;;
    *)
    ;;
esac
