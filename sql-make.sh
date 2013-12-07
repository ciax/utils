#!/bin/bash
cd ~/db
sql-schema sch-device.tsv
for i in *.tsv; do
    sql-insert $i
done
