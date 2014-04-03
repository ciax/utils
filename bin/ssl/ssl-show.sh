#!/bin/bash
# Required command: openssl
# Required scripts: func.app
. func.app
_usage "[site]"
cd ~/.var
openssl x509 -text -noout -in $1.crt
