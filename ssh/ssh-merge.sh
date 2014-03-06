#!/bin/bash
# Required script: edit-merge, ssh-trim, ssh-valid
# Required packages: coreutils(cut,grep),diffutils(cmp),openssh-client(ssh,scp)
# Join to the group which opject host is involved
# Usage: ssh-merge (user@host) ..
# If no args, then hosts are picked up from authorized_keys
arg=$*
rath=.ssh/authorized_keys
lath=~/$rath
rinv=.ssh/invalid_keys
linv=~/$rinv
rpub=.ssh/id_rsa.pub
lpub=~/$rpub
tath=~/.ssh/tath,
tinv=~/.ssh/tinv,
me=`cut -d' ' -f3 $lpub`
src=$(ssh-valid $arg `grep @ $lath|cut -d' ' -f3|grep -v $me`)
# Exclude what already exist in $lath
echo "-- Gathering"
trap "/bin/rm -f -- ~/.ssh/dst*" EXIT
for i in $src $arg; do
    if scp -pq $i:$rath $tath$i; then
        echo -n "authorized_keys"
        edit-merge $lath $tath$i
    elif scp -pq $i:$rpub $tath$i; then
        echo -n "id_rsa.pub"
        edit-merge $lath $tath$i
    else
        touch $tath$i
        continue
    fi
    if scp -pq $i:$rinv $tinv$i; then
        echo -n " and invalid_keys"
        edit-merge $linv $tinv$i
    else
        touch $tinv$i
    fi
    echo " is taken from $i"
done
ssh-trim
# Distribute
echo "-- Distribute"
shopt -s nullglob
for i in $tath*; do
    if ! cmp -s $i $lath; then
        host=${i#*,}
        scp -pq $lath $host:.ssh/ || continue
        echo "authorized_keys is sent to $host"
    fi
    rm $i
done
for i in $tinv*; do
    if ! cmp -s $i $linv; then
        host=${i#*,}
        scp -pq $linv $host:.ssh/ || continue
        echo "invalid_keys is sent to $host"
    fi
    rm $i
done
