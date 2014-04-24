#!/bin/bash
# Set alias for login
# Generate alias by pick up '#alias XXX' line from each files
while read head name par; do
    alias "$name=${head%:*}${par:+ $par}"
done < <(cd ~/bin;grep '^#alias' *)
[[ $0 == *utils.self-alias* ]] && { echo $C3"Self alias"$C0;alias; }
