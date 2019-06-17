#!/bin/bash
# Description: merge other branchies to HEAD
#alias gim
others="$(git branch|grep -v '*')"
for i in ${*:-$others}; do
    git merge origin/$i
done
