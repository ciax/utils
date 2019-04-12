#!/bin/bash
# Description: remove remote branch
#alias girm
[ "$1" ] || { echo "Usage: git-remove [branch]"; exit 1; }
git branch -d $1
git push origin :$1
