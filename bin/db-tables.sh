#!/bin/bash
# Required packages: coreutils(sort,tr),grep
# Required scripts: rc.app db-exec
# Required tables: *
# Desctiption: show tables
. rc.app
db-exec '.tables'|tr ' ' "\n"|grep .
