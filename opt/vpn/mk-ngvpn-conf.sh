#!/bin/bash
[ "$1" ] || { echo "Usage: mk-ovpnconf [zipfile]"; exit 1; }
out=ovpn.conf
tmp=ovpntmp
>$out
mkdir $tmp
cp "$1" $tmp
unzip -d $tmp "$tmp/$1"
while read a val; do
    case $a in
        ca) ca=$val;;
        cert) cert=$val;;
        key) key=$val;;
        *) echo "$a $val" >> $out
    esac
done < $tmp/*.conf

directive(){
    echo '<ca>'
    cat $tmp/$ca
    echo '</ca>'
    echo '<cert>'
    egrep -v '^ +' $tmp/$cert|grep -v :
    echo '</cert>'
    echo '<key>'
    cat $tmp/$key 
    echo '</key>'
}

directive|grep . >> $out
rm -r $tmp
