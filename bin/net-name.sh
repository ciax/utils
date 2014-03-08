#!/bin/bash
# Description: lookup network name
# Required scripts: db-register, info-subnet
# Required tables: subnet(network)
db-register "select id from subnet where network == '`info-subnet`';"
