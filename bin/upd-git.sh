#!/bin/bash
for i in ~/utils/ ~/cfg.*/;do
    echo "${C3}Git update for$C0 $i"
    cd $i
    git pull;git push
    file-register
done
