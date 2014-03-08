#!/bin/bash
cd
ba=.bash_completion
for i in bin lib db .var .trash;do
    [ -d $i ] && rm -r $i
done
[ -e "$ba" ] && rm $ba
echo "Unsetup complete!"