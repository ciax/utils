#!/bin/bash
# Other Environments
chkcmd(){
    type $1 >/dev/null 2>&1
}
chkcmd emacs && export EDITOR='emacs'
chkcmd most && export PAGER='most'
chkcmd emacs && export MOST_EDITOR='emacs %s -g %d'
