#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server Site
##  csr(Signning Request file) -> Submit to CA
##@ CA
## csr -> (Convert with ca.key) -> crt(Certificate) -> Send back to Server
cd ~/.var
. set.tempfile v3
case "$1" in
    '') . func.usage "(-s:server,-c:client,-a:ca) [ca] [site] ...";;
    -s) shift;echo "nsCertType=server" > $v3;;
    -c) shift;echo "nsCertType=client" > $v3;;
    -a) shift;echo "basicConstraints=CA:true" > $v3;;
    *);;
esac
ca=$1;shift
[ -s "$ca.key" ] || { echo "No ca key file"; exit; }
[ -s $ca.srl ] || opt="-CAcreateserial"
[ -s $v3 ] && ext="-extfile $v3"
for ss; do
    . ssl-request "$ss"
    openssl x509 -CA $ca.crt -CAkey $ca.key -req -in $ss.csr -out $ss.crt $opt $ext
done
