#!/bin/bash
shopt -s nullglob
eth=`netstat -i|cut -d' ' -f1|egrep '^eth'|sort|head -1`
netstat -nr|egrep -o "^([12].+) +0.0.0.0.*$eth"|cut -d'.' -f1-3
