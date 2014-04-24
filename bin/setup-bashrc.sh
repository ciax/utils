#!/bin/bash
# Description: setup bashrc
if ! grep -q '#initrc' ~/.bashrc ; then
    echo 'shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc' >> ~/.bashrc
fi
