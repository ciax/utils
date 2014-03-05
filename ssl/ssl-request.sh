#!/bin/bash
## SSL files (Server vs CA vs Client)
##@ Server
##  private.key(+pub.key) -> csr(Signning Request file)
input=
site=$1
. ssl-newkey $site
. set.field "'$site'" ssl
[ "$country" ] && input="$input/C=$country"
[ "$state" ] && input="$input/ST=$state"
[ "$city" ] && input="$input/L=$city"
[ "$company" ] && input="$input/O=$company"
[ "$section" ] && input="$input/OU=$section"
[ "$fdqn" ] && input="$input/CN=$fdqn"
[ "$email" ] && input="$input/emailAddress=$email"
openssl req -new -key $site.key ${input:+-subj "$input"} > $site.csr
[ -s "$site.csr" ] || { rm "$site.csr";echo "Generate CSR failed"; }
