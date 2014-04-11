#!/bin/bash
# Required scripts: file-register
# Description: update git repositories
for i in ~/utils/ ~/cfg.*/;do
    echo $C3"Git update for $i"$C0
    cd $i
    git pull
done
file-register
