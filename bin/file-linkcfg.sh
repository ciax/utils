#!/bin/bash
# Required scripts: func.link
# Description: make links to the specific dirs categorized by file type
# Desctiption: Files in cfg.*/ dirs will be classified into 'bin','db' ..
selflink(){
    egrep -Hr "^[#;]link(\($DIST\)|) " *[!~] |\
    while read spath dpath;do
        set - $(_abspath ${spath%:*})
	sdir=$1;src=$2
	set - $(_abspath $dpath)
        ddir=$1;dst=$2
        _mklink $sdir/$src $ddir ${dst:-$src}
        _showlink $ddir
    done
}
. func.link
echo $C3"File Registering (~/cfg.*)"$C0
for i in ~/cfg.*;do
    cd $i
    selflink
done
