#!/bin/bash
# Description: setup bashrc
if ! grep -q '#initrc' ~/.bashrc ; then
    str="shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc"
    echo "$str" >> ~/.bashrc
fi
