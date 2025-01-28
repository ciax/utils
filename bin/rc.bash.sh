#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian,Raspbian,Ubuntu): vim byobu ranger most rclone bash-completion python3-full
# Recommended packages(Debian,Ubuntu): cpuid msr-tools
# Recommended packages(Ubuntu): linux-tools-common
# Recommended packages: procps util-linux sysstat iproute2 numactl tcpdump bcc trace-cmd nicstat ethtool tiptop
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
