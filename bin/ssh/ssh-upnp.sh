#!/bin/bash
# Requied packages: miniupnpc
ext=42925
a=$(ip route)
l=${a##*src }
upnpc -d $ext tcp
upnpc -a $l 22 $ext tcp

