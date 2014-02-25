#!/bin/bash
while read pth cmd name; do
    $cmd $name=$(realpath $pth)
done < <(grep '^#alias' ~/utils/*.sh|tr '#:' ' ')
