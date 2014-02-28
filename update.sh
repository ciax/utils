#!/bin/bash
. set.color
# git
for i in ~/utils/ ~/cfg.*/;do
    echo "${C3}Git update for$C0 $i"
    cd $i
    git pull;git push
    file-register
done
# db
for i in mac login vpn route ssl;do
    sql-make $i|db-register
    echo "${C3}Database update for $i"
done
