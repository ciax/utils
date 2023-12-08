#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian): vim byobu ranger most rclone bash-completion
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
