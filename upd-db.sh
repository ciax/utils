#!/bin/bash
. set.color
for i in mac ssl ssh;do
    sql-make $i|db-register
    echo "${C3}Database update for $i"
done
