#!/bin/bash
# Description: git-pull/push for all branches
#link git-pull
#link git-push
cmd=${0##*-}
crnt=$(git branch|grep '*'|cut -d' ' -f2)
git fetch -a
for i in $(git branch -a|tr -d '* '|cut -d/ -f3|sort|uniq -d); do
    git checkout $i
    git $cmd
done
git checkout $crnt
