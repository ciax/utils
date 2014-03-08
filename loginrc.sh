#!/bin/bash
#link ~/.bash_completion
complete -r
for i in ~/utils/login.*; do . $i;done
