#!/bin/bash
# Required scripts: func.link
# Description: make links to the specific dirs categorized by file type
# Desctiption: Files in cfg.*/ dirs will be classified into 'bin','db' ..
selflink(){
    while read spath dpath;do
        read sdir src < <(_abspath ${spath%:*})
        read ddir dst < <(_abspath $dpath)
        _mklink $sdir/$src $ddir/${dst:-$src}
        _showlink $ddir
    done < <(egrep -Hr "^[#;]link(\($DIST\)|) " *)
}
. func.link
echo $C3"File Registering (~/cfg.*)"$C0
for i in ~/cfg.*;do
    cd $i
    selflink
done
