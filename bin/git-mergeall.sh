#!/bin/bash
# Required scripts: link-self
# Description: update git repositories
for i in $(git branch|grep -v '*');do
    git merge $i
done

