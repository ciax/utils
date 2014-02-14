#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
[ "$1" ] || . set.usage "[site name]"
cd ~/.var
site="$1"
if [ -s "$site.key" ] ;then
    echo "[[$site.key exists]]"
else
    openssl genrsa 2048 > $site.key
fi
chmod 600 $site.key
[ -s "$site.key" ] || { echo "Generate KEY file failed"; rm "$site.key"; exit 1; }
