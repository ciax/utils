#!/bin/bash

# エラーが発生したら即終了
set -e

echo "--- Debian Docker Setup Start ---"

# 1. 古いバージョンのアンインストール
echo "[1/5] 旧バージョンの削除..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y $pkg || true
done

# 2. リポジトリのセットアップ
echo "[2/5] 必要なパッケージのインストールとGPGキーの登録..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# リポジトリをsources.listに追加
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 3. Docker Engineのインストール
echo "[3/5] Docker Engineのインストール..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. ユーザーをdockerグループに追加
echo "[4/5] ユーザー権限の設定..."
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

# 5. 動作確認
echo "[5/5] インストールの確認..."
sudo docker --version
sudo docker compose version

echo "------------------------------------------------"
echo "完了しました！"
echo "※ ユーザー権限を反映させるため、一度ログアウトして再ログインするか、"
echo "   'newgrp docker' コマンドを実行してください。"
echo "------------------------------------------------"
