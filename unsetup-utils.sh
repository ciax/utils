#!/bin/bash
# Description: uninstall utils environment
bashrc-reset
cd
for i in bin .var .trash;do
    [ -d $i ] && rm -rf $i
done
echo "Unsetup complete!"
