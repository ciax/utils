#!/bin/bash
# Required packages: openssl
# Required scripts: func.app,ssl-request
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
. func.app
# Options
opt-s(){ echo "nsCertType=server" > $v3; }
opt-c(){ echo "nsCertType=client" > $v3; }
opt-a(){ echo "basicConstraints=CA:true" > $v3; }
cd ~/.var
_temp v3
_usage "(-s:server,-c:client,-a:ca) [ca] [site] ..."
ca=$1;shift
[ -s "$ca.key" ] || _abort "No ca key file"
[ -s $ca.srl ] || opt="-CAcreateserial"
[ -s $v3 ] && ext="-extfile $v3"
for ss; do
    . ssl-request "$ss"
    openssl x509 -CA $ca.crt -CAkey $ca.key -req -days 3650 -in $ss.csr -out $ss.crt $opt $ext
done
