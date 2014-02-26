#!/bin/bash
# Required Packages: expect,bsdmaintutils(column)
#alias lo
getstr(){
    db-device ' ' <<< "select command,user,host from login where id = '$1';"
}
list(){
    db-device <<< 'select id from login;'|sort|column -c60
}
[ "$1" ] || . set.usage "[host]" < <(list)
id=$1;shift
str="$(getstr $id) $*"
tun=$(db-device <<< "select tunnel from login where id == '$id';")
[ "$tun" ] && str="$(getstr $tun) $str"
pass=$(db-device <<< "select password from login where id == '$id';")
if [ "$pass" ] ; then
    expect <(cat <<-EOF
	set timeout 10
	spawn -noecho $str
	expect {
	  "(yes/no)?" { send "yes\n" ; exp_continue };
	  "word:" { send "$pass\n" ; exp_continue };
	  -re ".+ " { interact };
	}
	EOF
    )
else
    $str
fi
