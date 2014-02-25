#!/bin/bash
# Generate alias by pick up '#alias XXX' line from each files
while read head name par; do
    file=$(realpath ${head%:*})
    alias $name=$file${par:+ $par}
done < <(grep '^#alias' ~/utils/*.sh)
