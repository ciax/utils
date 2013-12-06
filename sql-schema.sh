#!/bin/bash
# Required script: set.usage.sh, db-expand.pl
#
## schema file (sch-*.tsv) contains 'table' and 'field' separated by <tab>
## The 'id' field is automatically added to the table as 'primary key'.
## If table name has ':' at the end, auto-incremented 'id' is set to the table.
## If the following 'field' content matches with a name of another 'table',
## it is treated as a "foreign key" refering to the 'id' field of the corresponding table.
## So the refered table must be shown above those field of line.
#
[ -e "$1" ] || . set.usage "[schema tsv file]"
sfx=':'
echo "begin;"
echo "pragma foreign_keys=on;"
while read key val; do
    tbase=${key%"$sfx"}
    if [ "$crnt" != "$tbase" ]; then
        create="$create$rstr"
        [ "$create" ] && create="$create);\n"
        crnt="$tbase"
        tables="$tables $crnt"
        echo "drop table if exists $crnt;"
        rstr=
        create="${create}create table $crnt ('id'"
        if [[ "$key" != *"$sfx" ]] ; then
            create="$create primary key"
        else
            create="$create integer primary key autoincrement"
        fi
    fi
    create="$create,'$val'"
    [[ "$tables" == *$val* ]] && rstr="$rstr,foreign key('$val') references $val('id')"
done < <(db-expand $1)
# Process Substitution makes the internal(while do) var effective at outside of that
echo -en $create
echo ");"
echo "commit;"
