#!/bin/bash
# Description: git-pull/push for all branches
#link git-pull
#link git-push
branches(){
    # list ids which exists in remote branch and local branch
    #  current branch will be placed on the tail to prevent double checkout
    for i in $(git branch -a|tr -d ' *'|cut -d/ -f3|sort|uniq -d);do
        [ $i = "$1" ] && shift || echo $i
    done
    [ "$1" ] || echo $crnt
}
cmd=${0##*-}
git fetch -a
crnt=$(git branch|grep '*'|tr -d ' *')
for i in $(branches $crnt); do
    git checkout $i
    git $cmd
done
# No need checkout if same branch listed at the last
[ "$i" = "$crnt" ] || git checkout $crnt
