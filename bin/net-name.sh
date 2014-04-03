#!/bin/bash
# Required scripts: db-exec, info-subnet
# Required tables: subnet(network)
# Description: lookup network name
db-exec "select id from subnet where network == '`info-subnet`';"
