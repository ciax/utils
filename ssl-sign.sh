#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
[ "$1" ] || . set.usage "[ca] [site] ..."
cd ~/.var
ca=$1;shift
[ -s "$ca.key" ] || { echo "No ca key file"; exit; }
[ -s $ca.srl ] || opt="-CAcreateserial"
for ss; do
    . ssl-mkcsr "$ss"
    openssl x509 -CA $ca.crt -CAkey $ca.key -req -in $ss.csr -out $ss.crt $opt
done
