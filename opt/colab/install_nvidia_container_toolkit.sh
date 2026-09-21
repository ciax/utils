#!/usr/bin/env bash
set -euo pipefail

echo "=================================================================="
echo " NVIDIA Container Toolkit Setup for WSL2 (Ubuntu/Debian)"
echo "=================================================================="

# 1. 前提パッケージの確認と導入
echo "[+] 必要な依存パッケージをインストール中..."
sudo apt-get update -y
sudo apt-get install -y curl gnupg2

# 2. NVIDIA公式GPGキーの追加
echo "[+] NVIDIA公式リポジトリのGPGキーを設定中..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg
sudo chmod a+r /etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg

# 3. aptリポジトリリストの作成
echo "[+] NVIDIA Container Toolkit リポジトリを追加中..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/etc/apt/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

# 4. パッケージリスト更新とインストール
echo "[+] パッケージリストを更新し、Toolkitをインストール中..."
sudo apt-get update -y
sudo apt-get install -y nvidia-container-toolkit

# 5. Dockerランタイムの構成設定
echo "[+] DockerデーモンにNVIDIAランタイムを設定中 (/etc/docker/daemon.json)..."
sudo nvidia-ctk runtime configure --runtime=docker

# 6. Dockerサービスの再起動
echo "[+] Dockerサービスを再起動中..."
if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running 2>/dev/null | grep -qE "running|degraded"; then
    sudo systemctl restart docker
else
    # systemdが無効なWSL2構成向け
    sudo service docker restart
fi

# 7. 動作検証 (nvidia-smi のコンテナ内実行)
echo "=================================================================="
echo " 動作検証を実行します (コンテナ内で nvidia-smi を実行)"
echo "=================================================================="
if sudo docker run --rm --gpus all ubuntu:22.04 nvidia-smi; then
    echo ""
    echo "[SUCCESS] NVIDIA Container Toolkit のセットアップが完了しました。"
    echo "これで先程のColabローカルランタイム起動スクリプトが正常にGPUを認識できます。"
else
    echo ""
    echo "[FAILED] GPUのパススルーに失敗しました。"
    echo "Windows側のNVIDIAドライバのバージョンやWSLのバージョンを確認してください。"
    exit 1
fi
