#!/usr/bin/env bash
# NAT用ネットワーク情報出力 (Debian12 / Bash)
# 引数: [wan|lan]（未指定は lan）
# 出力: netif,hostip,subnet,netmask,bcast,gw,mac（IPv6なし、cidr削除）
set -euo pipefail

usage() {
  echo "Usage: $0 {wan|lan}" >&2
  exit 2
}

# ===== 引数処理（未指定は lan、無効な値のみ usage） =====
ROLE="${1:-lan}"
if [[ "$ROLE" != "wan" && "$ROLE" != "lan" ]]; then
  usage
fi

# ===== 設定 =====
: "${ALLOW_CGNAT_WAN:=0}"   # 1でCGNAT(100.64.0.0/10)をWANとして許可
: "${WAN_IF:=}"             # 例: WAN_IF=enx000ec68ecf53
: "${LAN_IF:=}"             # 例: LAN_IF=enp2s0

is_skip_ifname() {
  case "$1" in
    lo|lo0|docker*|veth*|br-*|virbr*|vnet*|zt*|tailscale*|wg*|tun*|tap*|sit*|dummy*)
      return 0 ;;
    *) return 1 ;;
  esac
}

split_ip4() {
  local ip="$1" o1 o2 o3 o4
  IFS=. read -r o1 o2 o3 o4 <<<"$ip"
  printf "%s %s %s %s\n" "${o1:-0}" "${o2:-0}" "${o3:-0}" "${o4:-0}"
}

# LAN は 192.168/16 のみ
is_private_192() {
  read -r o1 o2 _ _ < <(split_ip4 "$1")
  [[ "$o1" -eq 192 && "$o2" -eq 168 ]]
}

# 予約/特殊（パブリックから除外）
is_reserved_or_special() {
  read -r o1 o2 _ _ < <(split_ip4 "$1")
  # 0/8, 127/8, 169.254/16, 224.0.0.0/4+, 240.0.0.0/4
  if [[ "$o1" -eq 0 || "$o1" -eq 127 || ( "$o1" -eq 169 && "$o2" -eq 254 ) || "$o1" -ge 224 ]]; then
    return 0
  fi
  # CGNAT 100.64/10（既定で WAN 扱いしない）
  if [[ "$o1" -eq 100 && "$o2" -ge 64 && "$o2" -le 127 && "$ALLOW_CGNAT_WAN" -ne 1 ]]; then
    return 0
  fi
  return 1
}

# パブリックIPv4 = 「192.168/16 ではない」かつ「予約/特殊ではない」
is_public_ipv4() {
  local ip="$1"
  if ! is_private_192 "$ip" && ! is_reserved_or_special "$ip"; then
    return 0
  fi
  return 1
}

cidr_to_netmask() {
  local cidr="$1" mask
  mask=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))
  printf "%d.%d.%d.%d\n" \
    $(( (mask>>24) & 255 )) $(( (mask>>16) & 255 )) $(( (mask>>8) & 255 )) $(( mask & 255 ))
}

ip4_to_int() {
  read -r a b c d < <(split_ip4 "$1")
  echo $(( (a<<24) + (b<<16) + (c<<8) + d ))
}

int_to_ip4() {
  local n="$1"
  printf "%d.%d.%d.%d\n" $(( (n>>24)&255 )) $(( (n>>16)&255 )) $(( (n>>8)&255 )) $(( n&255 ))
}

network_from_ip_cidr() {
  local ip="$1" cidr="$2" ipn mask net
  ipn=$(ip4_to_int "$ip")
  mask=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))
  net=$(( ipn & mask ))
  int_to_ip4 "$net"
}

get_default_route() {
  local def_if def_gw
  def_if=$(ip route show default 2>/dev/null | awk '/^default/ {for(i=1;i<=NF;i++){if($i=="dev"){print $(i+1); exit}}}')
  def_gw=$(ip route show default 2>/dev/null | awk '/^default/ {for(i=1;i<=NF;i++){if($i=="via"){print $(i+1); exit}}}')
  printf "%s %s\n" "${def_if:-}" "${def_gw:-}"
}

emit_info() {
  local ifn="$1" ip4="$2" cidr="$3" bcast="$4" gw="$5"
  local netmask subnet mac
  netmask=$(cidr_to_netmask "$cidr")
  subnet=$(ip -4 route show dev "$ifn" 2>/dev/null | awk '/proto kernel/ {print $1; exit}')
  if [[ -z "$subnet" ]]; then
    local netaddr
    netaddr=$(network_from_ip_cidr "$ip4" "$cidr")
    subnet="${netaddr}/${cidr}"
  fi
  mac=$(ip link show dev "$ifn" 2>/dev/null | awk '/link\/ether/ {print $2; exit}')

  echo "netif=${ifn}"
  echo "hostip=${ip4}"
  echo "subnet=${subnet}"
  echo "netmask=${netmask}"
  echo "bcast=${bcast}"
  echo "gw=${gw}"
  echo "mac=${mac^^}"
}

# ===== 既定ルート取得 =====
read -r DEF_IF DEF_GW < <(get_default_route)

# ===== IF一覧を一括取得（サブシェル回避）=====
ADDR_OUT="$(ip -4 -o addr show scope global 2>/dev/null)"

WAN_IF_SEL=""; WAN_IP=""; WAN_CIDR=""; WAN_BC=""; WAN_GW=""
LAN_IF_SEL=""; LAN_IP=""; LAN_CIDR=""; LAN_BC=""

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  ifn=$(awk '{print $2}' <<<"$line")
  if is_skip_ifname "$ifn"; then
    continue
  fi
  ipcidr=$(awk '{print $4}' <<<"$line")
  ip4="${ipcidr%/*}"
  cidr="${ipcidr#*/}"
  bc=$(awk '{for(i=1;i<=NF;i++){if($i=="brd"){print $(i+1); exit}}}' <<<"$line")

  # WAN 優先: 既定ルートIF かつ public
  if [[ -z "$WAN_IF_SEL" ]] && is_public_ipv4 "$ip4"; then
    if [[ -n "$DEF_IF" && "$ifn" == "$DEF_IF" ]]; then
      WAN_IF_SEL="$ifn"; WAN_IP="$ip4"; WAN_CIDR="$cidr"; WAN_BC="$bc"; WAN_GW="$DEF_GW"
    fi
  fi
  # 次善: public のIF
  if [[ -z "$WAN_IF_SEL" ]] && is_public_ipv4 "$ip4"; then
    WAN_IF_SEL="$ifn"; WAN_IP="$ip4"; WAN_CIDR="$cidr"; WAN_BC="$bc"
    [[ -n "$DEF_IF" && "$ifn" == "$DEF_IF" ]] && WAN_GW="$DEF_GW"
  fi

  # LAN: 192.168/16（WAN と同一IFは除外）
  if [[ -z "$LAN_IF_SEL" ]] && is_private_192 "$ip4"; then
    if [[ -z "$WAN_IF_SEL" || "$ifn" != "$WAN_IF_SEL" ]]; then
      LAN_IF_SEL="$ifn"; LAN_IP="$ip4"; LAN_CIDR="$cidr"; LAN_BC="$bc"
    fi
  fi
done <<< "$ADDR_OUT"

# ===== 手動指定の上書き（任意） =====
if [[ -n "${WAN_IF:-}" ]]; then
  wline="$(ip -4 -o addr show dev "$WAN_IF" scope global 2>/dev/null | head -n1 || true)"
  if [[ -n "$wline" ]]; then
    wipcidr=$(awk '{print $4}' <<<"$wline")
    WAN_IF_SEL="$WAN_IF"
    WAN_IP="${wipcidr%/*}"
    WAN_CIDR="${wipcidr#*/}"
    WAN_BC=$(awk '{for(i=1;i<=NF;i++){if($i=="brd"){print $(i+1); exit}}}' <<<"$wline")
    WAN_GW=""
    [[ -n "$DEF_IF" && "$WAN_IF" == "$DEF_IF" ]] && WAN_GW="$DEF_GW"
  fi
fi

if [[ -n "${LAN_IF:-}" ]]; then
  lline="$(ip -4 -o addr show dev "$LAN_IF" scope global 2>/dev/null | head -n1 || true)"
  if [[ -n "$lline" ]]; then
    lipcidr=$(awk '{print $4}' <<<"$lline")
    LAN_IF_SEL="$LAN_IF"
    LAN_IP="${lipcidr%/*}"
    LAN_CIDR="${lipcidr#*/}"
    LAN_BC=$(awk '{for(i=1;i<=NF;i++){if($i=="brd"){print $(i+1); exit}}}' <<<"$lline")
  fi
fi

# ===== 出力（ROLEに応じて） =====
if [[ "$ROLE" == "wan" ]]; then
  if [[ -n "$WAN_IF_SEL" ]]; then
    emit_info "$WAN_IF_SEL" "$WAN_IP" "$WAN_CIDR" "$WAN_BC" "$WAN_GW"
  else
    for k in netif hostip subnet netmask bcast gw mac; do
      echo "${k}="
    done
  fi
else # lan
  if [[ -n "$LAN_IF_SEL" ]]; then
    emit_info "$LAN_IF_SEL" "$LAN_IP" "$LAN_CIDR" "$LAN_BC" ""
  else
    for k in netif hostip subnet netmask bcast gw mac; do
      echo "${k}="
    done
  fi
fi
