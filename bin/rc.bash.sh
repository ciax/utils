#!/bin/bash
shopt -s nullglob
# Recommended packages(Debian): byobu ranger most
# Boot strap
for i in ~/bin/rc.bash.*;do . $i;done
uniqenv PATH RUBYLIB
unset i
