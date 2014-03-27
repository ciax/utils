#!/bin/bash
## Vefiry the relationship
. rc.app
_usage "[ca name] [site name]" $1
cd ~/.var
cacrt="$1.crt";shift
[ -s "$cacrt" ] || _abort "No ca crt file"
site="$1.crt";shift
[ -s "$site" ] || _abort "No site crt file"
openssl verify -CAfile $cacrt $site

