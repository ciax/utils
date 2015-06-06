#!/bin/bash
# Required commands: find
# Description: unify the file permittion under the current/sub dir
#alias rwx
. func.msg
_warn "Set File Permissions"
shopt -s globstar
for i in **/;do chmod 755 $i;done
chmod 644 **/*.*
chmod 755 **/*.{sh,rb,py,pl,exp}
