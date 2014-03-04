#!/bin/bash
# Required script: set.usage.sh
# Required packages: coreutils(dirname,basename,head,tr),grep,nkf
## CSV files: ~/db/db-*.csv
## The 'id' field is automatically added to the table as 'primary key'.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.
schema(){
    local dir=$(dirname $1)
    local tbl=$(db-table $1)
    [[ "$tables" == *$tbl* ]] && return
    tables="$tables $tbl"
    local drop="drop table if exists $tbl;"
    local create="create table $tbl ('id' primary key"
    local fgnkeys=''
    while read col; do
        [ $col = '!id' ] && continue
        create="$create,'$col'"
        for db in $dir/db-$col*.$ext; do
            fgnkeys="$fgnkeys $col"
            schema $db
        done
    done < <(egrep "^!" $1|head -1|nkf -Lu|tr ",\t" "\n")
    for i in $fgnkeys; do
        create="$create,foreign key('$i') references $i('id')"
    done
    echo "$drop"
    echo "$create);"
}

shopt -s nullglob
[ -e "$1" ] || . set.usage "[csv|tsv file] .."
tables=''
echo "pragma foreign_keys=on;"
for i; do
    ext=${i##*.}
    schema $i
done

