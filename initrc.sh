#!/bin/bash
#link ~/.bash_completion
# Description: login script loader
shopt -s nullglob;for i in ~/bin/rc.*;do . $i;done #initrc
