#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
lookup(){
    echo "select * from ssl where id = '$1';"|db-device|cut -d, -f2-|tr , '\n'
}
[ "$1" ] || . set.usage "[site name]"
cd ~/.var
site="$1"
if [ -e "$site.key" ] ;then
    echo "[[$site.key exists]]"
else
    openssl genrsa 2048 > $site.key
fi
lookup $site|openssl req -new -key $site.key > $site.csr
echo
