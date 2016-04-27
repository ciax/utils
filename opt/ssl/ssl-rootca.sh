#!/bin/bash
# Generating Root Certificate file
#  1.Make own private key and certificate sign request (.key,.csr)
#  2.Sign .csr with own private key -> root.crt
#Required scripts: func.ssl ssl-request
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
. ssl-request
_usage "[site]"
openssl x509 -days 9999 -req -signkey $site.key < $site.csr > $site.crt
shopt -s nullglob
for i in $site.*;do mv $i $ca.${i#*.};done
