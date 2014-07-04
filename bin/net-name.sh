#!/bin/bash
# Required scripts: db-exec info-net
# Required tables: subnet(network)
# Description: lookup network name
eval "$(info-net)"
db-exec "select id from subnet where network == '$subnet';"
