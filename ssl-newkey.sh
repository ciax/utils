#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
[ "$1" ] || . set.usage "[site name]"
cd ~/.var
site="$1"
[ -e "$site.key" ] || openssl genrsa 2048 > $site.key
echo "select * from ssl where id = '$site';"|db-device|tr ',' '\n'\
|{ read;cat; }|openssl req -new -key $site.key > $site.csr
echo
