#!/bin/bash
# Required commands: find
# Description: unify the file permittion under the current/sub dir
#alias rwx
. func.msg
_warn "Set File Permissions"
shopt -s globstar
for i in **/;do chmod 755 $i;done
for i in **/*.*;do
    if [ -d "$i" ] ;then
        chmod 755 "$i"
    else
        chmod 644 "$i"
    fi
done 
for i in **/*.{sh,rb,py,pl,exp};do chmod 755 $i;done 
