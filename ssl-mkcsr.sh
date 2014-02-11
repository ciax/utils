#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
lookup(){
    echo "select * from ssl where id = '$1';"|db-device|cut -d, -f2-|tr , '\n'|grep .
}
. ssl-newkey $1
. set.tempfile input
if lookup $site > $input; then
    openssl req -new -key $site.key <$input > $site.csr
else
    openssl req -new -key $site.key > $site.csr
fi
echo
[ -s "$site.csr" ] || { rm "$site.csr";echo "Generate CSR failed"; }