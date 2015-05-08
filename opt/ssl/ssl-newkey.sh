#!/bin/bash
# Required scripts: func.ssl
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
. func.ssl
_usage "[site]"
if [ -s "$site.key" ] ;then
    _warn "$site.key exists"
else
    openssl genrsa 2048 > $site.key
fi
chmod 600 $site.key
[ -s "$site.key" ] || { rm "$site.key"; _abort "Generate KEY file failed"; }
