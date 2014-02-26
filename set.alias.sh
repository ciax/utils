#!/bin/bash
# Generate alias by pick up '#alias XXX' line from each files
while read head name par; do
    alias $name=${head%:*}${par:+ $par}
done < <(cd ~/bin;grep '^#alias' *)
