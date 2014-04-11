#!/bin/bash
# Description: push to git repositories
for i in ~/utils/ ~/cfg.*/;do
    echo $C3"Git push for $i"$C0
    cd $i
    git config credential.helper store
    git push
done
