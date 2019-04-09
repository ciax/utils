#!/bin/bash
# Description: update all git branches
for i in $(git branch|sort|tr -d '*'); do
    git checkout $i
    git pull
done
