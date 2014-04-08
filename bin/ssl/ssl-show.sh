#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar
. func.getpar
_usage "[site]"
cd ~/.var
openssl x509 -text -noout -in $1.crt
