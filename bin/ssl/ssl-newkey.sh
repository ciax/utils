#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
. func.getpar
_usage "[site name]"
cd ~/.var
site="$1"
if [ -s "$site.key" ] ;then
    echo $C3"$site.key exists"$C0
else
    openssl genrsa 2048 > $site.key
fi
chmod 600 $site.key
[ -s "$site.key" ] || { rm "$site.key"; _abort "Generate KEY file failed"; }
