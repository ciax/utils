#!/bin/bash
# Description: uninstall utils environment
bashrc-reset
cd
for i in bin .trash .var/cache cfg.*;do
    [ -d $i ] && rm -rf $i
done
echo "Unsetup complete!"
