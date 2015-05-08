#!/bin/bash
# Prepare for CIAX daemon
gen2prt iid > /dev/null 2>&1 || {
    gen2cmd init
    gen2cmd login
    gen2cmd setinst 1
    gen2cmd logout
}
gen2red

