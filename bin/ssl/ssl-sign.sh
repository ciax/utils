#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar ssl-request
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
. func.getpar
. func.temp
# Options
opt-s(){ echo "nsCertType=server" > $v3; } #server
opt-c(){ echo "nsCertType=client" > $v3; } #client
opt-a(){ echo "basicConstraints=CA:true" > $v3; } #ca
cd ~/.var
_temp v3
_usage "[ca] [site] ..."
ca=$1;shift
[ -s "$ca.key" ] || _abort "No ca key file"
[ -s $ca.srl ] || opt="-CAcreateserial"
[ -s $v3 ] && ext="-extfile $v3"
for ss; do
    . ssl-request "$ss"
    openssl x509 -CA $ca.crt -CAkey $ca.key -req -days 3650 -in $ss.csr -out $ss.crt $opt $ext
done
