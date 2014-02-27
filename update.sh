#!/bin/bash
. set.color
# git
for i in ~/utils/ ~/cfg.*/;do
    echo "${C3}Git update for$C0 $i"
    cd $i
    git pull;git push
    reg-files
done
# db
for i in mac login;do
    sql-make $i|db-device
    echo "${C3}Database update for $i"
done
