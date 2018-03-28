#!/bin/bash
# Required scripts: db-exec
# Required tables: *
# Description: show tables
db-exec '.tables'|tr ' ' "\n"|grep .
