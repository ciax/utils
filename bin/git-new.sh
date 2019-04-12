#!/bin/bash
# Description: create new branch and move, set remote
#alias gin
[ "$1" ] || { echo "Usage: git-new [branch]"; exit 1; }
git checkout -b $1
git push --set-upstream origin $1

