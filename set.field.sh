#!/bin/bash
# Set variables corresponding field names of table;
setvar(){
    db-register -i "$1" > $db
    if [ -s $db ] ; then
        while read var eq str;do
            [ "$2" ] && str=''
            $cmd "$var='$str'"
        done < $db
    else
        setvar "select * from $tbl where id == (select min(id) from $tbl)" unset
    fi
}
set -f
[ "$2" ] || . set.usage "[id] [table1] (table2..)"
case $0 in
    *set.field*) cmd='echo';;
    *) cmd='eval';;
esac
sub="'$1'";shift
for tbl; do
    [ "$sql" ] && sub="(select $tbl $sql)"
    sql="from $tbl where id == $sub"
done
sql="select * $sql;"
. set.tempfile db
setvar "$sql"
unset sub sql cmd setvar
