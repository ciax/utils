#!/bin/bash
# Description: initial login script loader
#link ~/.bash_completion
complete -r
for i in ~/utils/login.*; do . $i;done
