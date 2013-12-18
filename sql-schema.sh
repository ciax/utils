#!/bin/bash
# Required script: set.usage.sh, db-expand.pl
#
## schema file (sch-*.tsv) contains 'table' and 'field' separated by <tab>
## The 'id' field is automatically added to the table as 'primary key'.
## If ':' is attached to the table name, auto-incremented 'id' is set to the table.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.
## So the refered table must be shown above those field of line.
## If '!' is attached to the field name, this field is set to unique restriction. 

[ -e "$1" ] || . set.usage "[schema tsv file]"
tsfx=':'
fsfx='!'
echo "pragma foreign_keys=on;"
while read key val; do
    tbase=${key%"$tsfx"}
    fbase=${val%"$fsfx"}
    if [ "$crnt" != "$tbase" ]; then
        create="$create$rstr"
        [ "$create" ] && create="$create);\n"
        crnt="$tbase"
        tables="$tables $crnt"
        echo "drop table if exists $crnt;"
        rstr=
        create="${create}create table $crnt ('id'"
        if [ "$key" = "$tbase" ] ; then
            create="$create primary key"
        else
            create="$create integer primary key autoincrement"
        fi
    fi
    create="$create,'$fbase'"
    [ "$val" = "$fbase" ] || create="$create unique"
    if [[ "$tables" == *$fbase* ]] ; then
        rstr="$rstr,foreign key('$fbase') references $fbase('id')"
    fi
done < <(db-expand $1)
# Process Substitution makes the internal(while do) var effective at outside of that
echo -en $create
echo ");"
