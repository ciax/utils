#!/bin/bash
#link ~/.bash_completion
complete -r
for i in ~/utils/rc.*; do . $i;done
