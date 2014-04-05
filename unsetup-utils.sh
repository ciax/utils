#!/bin/bash
# Description: uninstall utils environment
cd
for i in bin lib db .var .trash;do
    [ -d $i ] && rm -rf $i
done
[ -d /etc/skel ] && cp /etc/skel .
echo "Unsetup complete!"
