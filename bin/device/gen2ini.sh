#!/bin/bash
[ -d ~/gen2 ] || { echo "NO gen2, exit";exit; }
source ~/gen2/conf/bashrc


#This will define environment variables that are needed.
#Until these variables are defined at user login, you must start level 0 manually:
omsrv="./remoteObjects/remoteObjectManagerSvc.py --log=$LOGHOME/ro_mgrsvc.log --output=$LOGHOME/ro_mgrsvc_stdout.log --loglevel=info --detach"
#To start up the web-based control GUI:
bmsrv="./bin/bm_web.py --config=ciax --host=192.168.132.4 --log=$LOGHOME/bm_web.log --detach"

ps -ef|grep -q "$bmsrv" || {
    ps -ef|grep -q "$omsrv" || {
        cd $PYHOME
        $omsrv
    }
    cd $HOME/gen2
    $bmsrv
#ACCESS port 20000 for web page
#Press "Refresh"; you should see Level 0 running.  Press "Push Out".

#Alternatively, you can run the shell based one:
    cd $GEN2HOME
    ./BootManager.py --config=ciax <<EOF
setup()
start(1)
start(2)
start(3)
start(4)
start(5)
EOF
}

PYTHONPATH=~/gen2/share/Git/python
[ -d "$PYTHONPATH" ] || { echo "NO OSS files"; exit; }
ln -sf $PYTHONPATH/Gen2/client/g2cmd.py ~/bin/OSST_ciaxTSCcommand
ln -sf $PYTHONPATH/SOSS/status/screenPrint.py ~/bin/OSSC_screenPrint

gen2prt iid > /dev/null 2>&1 || {
    gen2cmd init
    gen2cmd login
    gen2cmd setinst 1
    gen2cmd logout
}
gen2red
#rund
