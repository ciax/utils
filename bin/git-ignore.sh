#!/bin/bash
# Description: remove remote branch
#alias gig
[ "$1" ] || { echo "Usage: git-ignore [files]"; exit 1; }
: > .gitignore
for i ;do
    [ -e $i ] && echo $i >> .gitignore
done
find -type l | sed 's/^\.\//\//' >> .gitignore
cat .gitignore
