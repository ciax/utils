#!/bin/bash
# Description: merge other branchies to HEAD
for i in $(git branch|grep -v '*'); do
    git merge $i
done
