#!/bin/bash
# UPDATE before login
(git-update >/dev/null 2>&1;db-update >/dev/null 2>&1) &

