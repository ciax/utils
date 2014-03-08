#!/bin/bash
# Required scripts: db-register, info-subnet
# Required tables: subnet(network)
db-register "select id from subnet where network == '`info-subnet`';"
