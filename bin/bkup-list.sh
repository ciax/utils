#!/bin/bash
#alias bkl
# Descripton: display backed up files
bkup-exec "select name,count(*) from list group by name;"
