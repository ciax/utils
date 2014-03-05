#!/bin/bash
# Generate alias by pick up '#alias XXX' line from each files
case $0 in
    *set.alias*) cmd="echo";;
    *) cmd="alias";;
esac
while read head name par; do
    $cmd $name=${head%:*}${par:+ $par}
done < <(cd ~/bin;file-clean;grep '^#alias' *)
