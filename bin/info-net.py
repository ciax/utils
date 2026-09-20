#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import re
import os
import ipaddress
import sys

def is_wsl():
    """実行環境がWSLであるかを判定する"""
    try:
        if os.path.exists('/proc/version'):
            with open('/proc/version', 'r') as f:
                content = f.read().lower()
                if 'microsoft' in content or 'wsl' in content:
                    return True
    except Exception:
        pass
    return False

def get_wsl_host_network_info():
    """[WSL用] Windowsホストの物理ネットワーク情報（MAC含む）を取得してフォーマットする"""
    info = {"netif": "", "hostip": "", "subnet": "", "netmask": "", "bcast": "", "gw": "", "mac": ""}
    
    # 物理IPとInterfaceIndexの取得 (172.*, 127.*, 169.254.* を除外した最初のIPv4を取得)
    ps_cmd = '''
    $ip = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "172.*" -and $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -First 1
    if ($ip) {
        Write-Output "$($ip.InterfaceAlias),$($ip.IPAddress),$($ip.PrefixLength),$($ip.InterfaceIndex)"
    }
    '''
    
    try:
        cmd = ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_cmd]
        res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=sys.stderr, check=True)
        out = res.stdout.decode('cp932', errors='ignore').strip()
        
        if out and "," in out:
            parts = out.split(",")
            if len(parts) == 4:
                info["netif"] = parts[0]
                ip_str = parts[1]
                prefix = int(parts[2])
                ifindex = parts[3]
                
                interface = ipaddress.IPv4Interface(f"{ip_str}/{prefix}")
                network = interface.network
                
                info["hostip"] = ip_str
                info["subnet"] = str(network.network_address)
                info["netmask"] = str(interface.netmask)
                info["bcast"] = str(network.broadcast_address)
                
                # InterfaceIndexを元にMACアドレスを取得して、コロン区切りの小文字に整形
                ps_mac_cmd = f'(Get-NetAdapter -InterfaceIndex {ifindex}).MacAddress'
                cmd_mac = ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_mac_cmd]
                res_mac = subprocess.run(cmd_mac, stdout=subprocess.PIPE, stderr=sys.stderr, check=True)
                mac_str = res_mac.stdout.decode('cp932', errors='ignore').strip()
                # Windowsの「00-11-22-...」形式を「00:11:22:...」形式に変換
                if mac_str:
                    info["mac"] = mac_str.replace("-", ":").lower()
    except Exception as e:
        print(f"[WSLエラー] IP/MAC取得中にエラーが発生しました: {e}", file=sys.stderr)

    # デフォルトゲートウェイの取得
    ps_gw_cmd = '''
    $gw = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Where-Object { $_.NextHop -ne "0.0.0.0" } | Select-Object -First 1 -ExpandProperty NextHop
    if ($gw) {
        Write-Output $gw
    }
    '''
    
    try:
        cmd_gw = ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps_gw_cmd]
        res_gw = subprocess.run(cmd_gw, stdout=subprocess.PIPE, stderr=sys.stderr, check=True)
        gw_str = res_gw.stdout.decode('cp932', errors='ignore').strip()
        if re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$", gw_str):
            info["gw"] = gw_str
    except Exception as e:
        print(f"[WSLエラー] GW取得中にエラーが発生しました: {e}", file=sys.stderr)

    return info

def get_linux_native_network_info():
    """[通常Linux用] 自身の物理ネットワーク情報（MAC含む）をシステムから取得する"""
    info = {"netif": "", "hostip": "", "subnet": "", "netmask": "", "bcast": "", "gw": "", "mac": ""}
    try:
        res = subprocess.run(["ip", "route", "show", "default"], capture_output=True, text=True, check=True)
        route_line = res.stdout.strip()
        
        gw_match = re.search(r"via\s+([^\s]+)", route_line)
        if gw_match:
            info["gw"] = gw_match.group(1)
            
        dev_match = re.search(r"dev\s+([^\s]+)", route_line)
        if dev_match:
            netif = dev_match.group(1)
            info["netif"] = netif
            
            # IP関連情報の取得
            res_addr = subprocess.run(["ip", "-o", "-f", "inet", "addr", "show", netif], capture_output=True, text=True, check=True)
            addr_line = res_addr.stdout.strip()
            
            cidr_match = re.search(r"inet\s+([^\s]+)", addr_line)
            bcast_match = re.search(r"brd\s+([^\s]+)", addr_line)
            
            if cidr_match:
                interface = ipaddress.IPv4Interface(cidr_match.group(1))
                network = interface.network
                
                info["hostip"] = str(interface.ip)
                info["subnet"] = str(network.network_address)
                info["netmask"] = str(interface.netmask)
            
            if bcast_match:
                info["bcast"] = bcast_match.group(1)
                
            # MACアドレスの取得
            res_link = subprocess.run(["ip", "link", "show", netif], capture_output=True, text=True, check=True)
            link_line = res_link.stdout.strip()
            mac_match = re.search(r"link/ether\s+([0-9a-fA-F:]{17})", link_line)
            if mac_match:
                info["mac"] = mac_match.group(1).lower()
    except Exception as e:
        print(f"[Linuxエラー] 情報取得中にエラーが発生しました: {e}", file=sys.stderr)
    return info

def main():
    if is_wsl():
        net_info = get_wsl_host_network_info()
    else:
        net_info = get_linux_native_network_info()

    # シェルスクリプトのevalで安全に読み込めるよう、値をシングルクォーテーションで囲む
    print(f"netif='{net_info['netif']}'")
    print(f"hostip='{net_info['hostip']}'")
    print(f"subnet='{net_info['subnet']}'")
    print(f"netmask='{net_info['netmask']}'")
    print(f"bcast='{net_info['bcast']}'")
    print(f"gw='{net_info['gw']}'")
    print(f"mac='{net_info['mac']}'")

if __name__ == "__main__":
    main()
