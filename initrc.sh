#!/bin/bash
#link ~/.bash_login
# Description: login script loader
[ -f .profile ] && . .profile
shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc
