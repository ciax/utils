#!/bin/bash
# Required scripts: db-exec
# Required tables: *
# Desctiption: show tables
db-exec '.tables'|tr ' ' "\n"|grep .
