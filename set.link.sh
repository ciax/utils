#!/bin/bash
# Make own symbolic link to HOME/bin
ln -sf $(realpath $0) ~/bin/$1
