#!/bin/bash
for i in ~/utils/ ~/cfg.*/;do
    echo $C3"Git update for $i"$C0
    cd $i
    git pull;git push
    file-register
done
