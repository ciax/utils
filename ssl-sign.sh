#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
[ "$1" ] || . set.usage "[ca name] [site name]"
cd ~/.var
ca=$1;shift
[ -s "$ca.key" ] || { echo "No ca key file"; exit; }
site=$1;shift
. ssl-mkcsr "$site"
[ -s $ca.srl ] || opt="-CAcreateserial"
openssl x509 -CA $ca.crt -CAkey $ca.key -req -in $site.csr -out $site.crt $opt
