#!/bin/bash
. src.app
_usage "[site]"
cd ~/.var
openssl x509 -text -noout -in $1.crt
