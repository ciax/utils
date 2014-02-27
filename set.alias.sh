#!/bin/bash
# Generate alias by pick up '#alias XXX' line from each files
pick(){ cd ~/bin;file-clean;grep '^#alias' *; }
case $0 in
    *set.alias*) pick;;
    *)
        while read head name par; do
            alias $name=${head%:*}${par:+ $par}
        done < <(pick)
        ;;
esac
