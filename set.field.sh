#!/bin/bash
# Set variables corresponding field names of table;
[ "$2" ] || . set.usage "[table] [id]"
tbl=$1;val=$2
db=~/.var/db-register.sq3
case $0 in
    *set.field*) cmd='echo';;
    *) cmd='eval';;
esac
while read var eq str;do
    $cmd "$var='$str'"
done < <(sqlite3 -line $db <<< "select * from $tbl where id == '$val';")
