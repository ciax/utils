#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
[ "$1" ] || . set.usage "[ca name] [site name]"
cd ~/.var
cakey=$1.key;shift
[ -e "$cakey" ] || { echo "No ca key file"; exit; }
site=$1;shift
[ -e "$site.csr" ] || { echo "No csr file" ; exit; }
openssl x509 -days 9999 -req -signkey $cakey < $site.csr > $site.crt
rm $site.csr
