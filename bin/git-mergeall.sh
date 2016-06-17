#!/bin/bash
# Required scripts: file-selflink
# Description: update git repositories
for i in $(git branch|grep -v '*');do
    git merge $i
done

