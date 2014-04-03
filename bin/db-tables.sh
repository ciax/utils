#!/bin/bash
# Required commands: tr,grep
# Required scripts: func.app db-exec
# Required tables: *
# Desctiption: show tables
. func.app
db-exec '.tables'|tr ' ' "\n"|grep .
