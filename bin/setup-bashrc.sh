#!/bin/bash
# Description: setup bashrc
[ -f ~/.bashrc ] && grep -q '#initrc' ~/.bashrc && exit
echo 'shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc' >> ~/.bashrc