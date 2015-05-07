#!/bin/bash
# Gen2 Boot up levels
source ~/gen2/conf/bashrc
PYTHONPATH=~/gen2/share/Git/python
[ -d "$PYTHONPATH" ] || { echo "NO OSS files"; exit; }
ln -sf $PYTHONPATH/Gen2/client/g2cmd.py ~/bin/OSST_ciaxTSCcommand
ln -sf $PYTHONPATH/SOSS/status/screenPrint.py ~/bin/OSSC_screenPrint
