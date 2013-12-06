#!/bin/bash
# Set Color
# ESC[(A);(B)(C)m # A: 0=dark 1=light # B: 3=FG 4=BG # C: 1=R 2=G 4=B
if [ -t 2 ] ; then
    for i in 1 2 3 4 5 6 7 ; do
        eval "C${i}=\$'\\e[1;3${i}m'"
    done
    C0=$'\e[0m'
fi