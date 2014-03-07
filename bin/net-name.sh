#!/bin/bash
db-register "select id from subnet where network == '`info-subnet`';"
