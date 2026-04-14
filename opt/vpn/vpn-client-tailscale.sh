#!/usr/bin/env bash
#Description: tailscale(VPN) utils
#alias ts
. func.getpar

case $1 in
    setup) # Setup tailscale
	curl -fsSL https://tailscale.com/install.sh | sh
    ;;
    up) # Start tailscale
	eval $(info-net)
	sudo tailscale up --accept-routes --accept-dns=false --advertise-routes=$subnet
	;;
    down) # Stop tailscale
	sudo tailscale down
	;;
    *)
        _disp_usage "[command]"
        _caseitem | _colm 1>&2
        _fexit 2
	;;
esac



