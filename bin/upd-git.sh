#!/bin/bash
# Description: update git repositories
# Required packages: git
# Required scripts: file-register
for i in ~/utils/ ~/cfg.*/;do
    echo $C3"Git update for $i"$C0
    cd $i
    git pull;git push
done
file-register
file-clean ~/bin ~/db ~/lib ~/.var