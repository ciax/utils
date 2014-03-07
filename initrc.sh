#!/bin/bash
#link ~/.bash_completion
complete -r
for i in ~/bin/rc.*; do . $i;done
