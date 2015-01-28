#!/bin/bash
# Required scripts: func.temp
# Description: append stdin to config file which is included in stdin as a comment
# Usage: cfg-append < cfgfile
. func.temp
_usage "<newcfg>"
_temp copy
rem=$(tee $copy|grep "^#/")
file=${rem#*#}
[ "$file" ] || _abort "No cfg file name"
[ -e "$file" ] || sudo touch $file
[ -e "$file.org" ] || sudo mv $file $file.org
sudo cp $file.org $file
sudo grep -v "^#" $copy | sudo tee -a $file
