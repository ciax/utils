#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian,Raspbian,Ubuntu): vim byobu ranger most rclone bash-completion
# Recommended packages: procps util-linux sysstat iproute2 numactl tcpdump linux-tools-common bcc trace-cmd nicstat ethtool tiptop cpuid msr-tools 
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
