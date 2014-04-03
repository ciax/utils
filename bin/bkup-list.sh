#!/bin/bash
#alias bkl
# Required scripts: bkup-exec
# Descripton: display backed up files
bkup-exec "select name,count(*) from list group by name;"
