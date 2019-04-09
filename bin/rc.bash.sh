#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian): byobu
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
