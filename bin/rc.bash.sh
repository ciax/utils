#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian,Raspbian,Ubuntu): vim byobu ranger most rclone bash-completion
# Recommended packages(Debian,Ubuntu): cpuid linux-tools-common msr-tools
# Recommended packages: procps util-linux sysstat iproute2 numactl tcpdump bcc trace-cmd nicstat ethtool tiptop
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
