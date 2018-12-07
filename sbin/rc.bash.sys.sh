#!/bin/bash
# Scripts which needs sudo
cfg-hosts -s

#### Aalias ####
alias kilg='sudo killall -i -I -r'
alias pki='pkg install'
alias pku='pkg upd'

#### User switching ####

# Switch user (alternative to su)
switch_user(){ #alias sb
    sudo -i ${1:+-u $1}
}
# Switch user by name (GID = 100)
user_alias(){
    for l in $(cut -d: -f1,4 /etc/passwd|grep ':100$'); do
        i=${l%:*}
        alias :$i="sudo -iu $i"
    done
}
user_alias >/dev/null
