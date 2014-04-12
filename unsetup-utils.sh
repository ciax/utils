#!/bin/bash
# Description: uninstall utils environment
cd
for i in bin .var .trash;do
    [ -d $i ] && rm -rf $i
done
shopt -s dotglob
[ -d /etc/skel ] && cp /etc/skel/* .
echo "Unsetup complete!"
