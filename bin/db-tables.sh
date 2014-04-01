#!/bin/bash
# Required packages: coreutils(sort,tr),grep
# Required scripts: src.app db-exec
# Required tables: *
# Desctiption: show tables
. src.app
db-exec '.tables'|tr ' ' "\n"|grep .
