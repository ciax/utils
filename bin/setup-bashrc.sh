#!/bin/bash
# Description: setup bashrc
if ! grep -q '#initrc' ~/.profile ; then
    echo 'shopt -s nullglob;for i in ~/bin/rc.login.*;do . $i;done #initrc' >> ~/.profile
fi
if ! grep -q '#initrc' ~/.bash_logout ; then
    echo 'shopt -s nullglob;for i in ~/bin/rc.logout.*;do . $i;done #initrc' >> ~/.bash_logout
fi
