[How to make wireguard configuration files?]

1. Pub Key generation and share PC information to others.
   CMD : wg-setup-peer
   OUTPUT : ~/etc/wg_peer.$HOSTNAME.txt
            ~/.wg/privkey
	    
2. Peer Server Setting (Nat to Nat or Terminal to Nat)
   CMD : wg-setup-server
   INPUT : ~/etc/wg_peer.*.txt 
   OUTPUT : /etc/wireguard/wg0.conf

3. Peer Client Setting (Nat to Nat)
   CMD : wg-setup-client
   INPUT : ~/etc/wg_peer.(SERVER).txt
   OUTPUT : /etc/wireguard/wg0.conf

4. Terminal Client Setting
   CMD : wg-setup-terminal [0,1,...] 
   OUTPUT : ~/.wg/client/privkey#.cli
            ~/.wg/client/wg0.client#.peer

% Obsolated
  wg-mkpeer : ~/etc/wg0.$HOSTNAME.peer
