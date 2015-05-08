#!/bin/bash
# Required scripts: func.ssl
# Description: Vefiry the relationship
. func.ssl
_usage "[site]"
[ -s "$ca.crt" ] || _abort "No ca crt file"
[ -s "$site.crt" ] || _abort "No site crt file"
openssl verify -CAfile $ca.crt $site.crt

