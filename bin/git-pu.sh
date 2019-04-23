#!/bin/bash
# Description: git-pull/push for all branches
#link git-pull
#link git-push
cmd=${0##*-}
crnt=$(git branch|grep '*'|tr -d ' *')
echo "Current Branch [$crnt]"
for i in $(git branch -a|tr -d ' *'|cut -d/ -f3|sort|uniq -d); do
    git checkout $i
    git $cmd
done
# No need checkout if same branch listed at the last
[ "$i" = "$crnt" ] || git checkout $crnt
