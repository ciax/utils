#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar ssl-request
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
. func.getpar
shopt -s nullglob
_usage "[site]"
cd ~/.var
site=$1
. ssl-request $site
openssl x509 -days 9999 -req -signkey $site.key < $site.csr > $site.crt
for i in $site.*;do mv $i rootca.${i#*.};done
