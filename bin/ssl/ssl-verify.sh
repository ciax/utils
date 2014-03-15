#!/bin/bash
## Vefiry the relationship
_usage "[ca name] [site name]" $1
cd ~/.var
cacrt="$1.crt";shift
[ -s "$cacrt" ] || { echo "No ca crt file"; exit; }
site="$1.crt";shift
[ -s "$site" ] || { echo "No site crt file"; exit; }
openssl verify -CAfile $cacrt $site

