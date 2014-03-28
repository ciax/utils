#!/bin/bash
# Required packages: coreutils(sort,tr),grep
# Required scripts: rc.app db-register
# Required tables: *
# Desctiption: show tables
. rc.app
db-register '.tables'|tr ' ' "\n"|grep .
