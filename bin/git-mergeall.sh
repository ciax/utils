#!/bin/bash
# Required scripts: git-updall
# Description: merge other branchies to HEAD
. git-updall
for i in $others; do
    git merge $i
done
