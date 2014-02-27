#!/bin/bash
echo "select id from subnet where network == '`info-subnet`';"|db-register
