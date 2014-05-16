#!/bin/bash
# Required scripts: func.ssl
# Description:  Check the consistency of SSL files
. func.ssl
show(){
    [ -s "$site.$1" ] || return
    echo -n "$1:"
    openssl $2 -in "$site.$1" -modulus -noout| openssl md5
}
_usage "[site]"
show key rsa
show csr req
show crt x509
