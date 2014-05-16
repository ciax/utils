#!/bin/bash
# Required packages: openssl
# Required scripts: func.getpar
. func.ssl
_usage "[site]"
openssl x509 -text -noout -in $site.crt
