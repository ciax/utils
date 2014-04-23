#!/bin/bash
# Description: setup bashrc
[ -f ~/.bashrc ] && grep -q '#initrc' ~/.bashrc && exit
grep '#initrc$' $0 >> ~/.bashrc
shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc
