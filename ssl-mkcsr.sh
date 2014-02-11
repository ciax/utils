#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
lookup(){
    echo "select * from ssl where id = '$1';"|db-device|cut -d, -f2-|tr , '\n'
}
. ssl-newkey $1
lookup $site|openssl req -new -key $site.key > $site.csr
echo
[ -s "$site.csr" ] || { rm "$site.csr";echo "Generate CSR failed"; }