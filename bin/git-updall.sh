#!/bin/bash
# Description: update all git branches
crnt=$(git branch --contains|cut -d' ' -f2)
others="$(git branch|grep -v '*')"
for i in $others $crnt; do
    git checkout $i
    git pull
done
