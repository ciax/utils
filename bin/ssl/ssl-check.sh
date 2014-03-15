#!/bin/bash
## Check the consistency of SSL files
. rc.app
show(){
    [ -s "$site.$1" ] || return
    echo -n "$1:"
    openssl $2 -in "$site.$1" -modulus -noout| openssl md5
}
_usage "[site]" $1
cd ~/.var
site="$1"
show key rsa
show csr req
show crt x509
