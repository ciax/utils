#!/bin/bash
# Description: lookup network name
# Required scripts: db-exec, info-subnet
# Required tables: subnet(network)
db-exec "select id from subnet where network == '`info-subnet`';"
