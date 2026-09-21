#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="colab-local-cuda"
CONTAINER_NAME="colab-local-cuda-runner"
HOST_PORT=8888
WORK_DIR="${HOME}/colab_workspace"
DOCKERFILE_PATH="./Dockerfile.colab"

mkdir -p "${WORK_DIR}"

cat <<'EOF' > "${DOCKERFILE_PATH}"
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Layer 1: OS依存関係 (キャッシュ保持)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Layer 2: Jupyter / Colab接続パッケージ
RUN pip3 install --no-cache-dir \
    jupyterlab \
    notebook \
    jupyter_http_over_ws \
    ipykernel \
    numpy \
    pandas \
    matplotlib

# Layer 3: 拡張機能の有効化（新旧Jupyter Serverコマンド対応）
RUN jupyter server extension enable --py jupyter_http_over_ws || jupyter serverextension enable --py jupyter_http_over_ws

# Layer 4: PyTorch (大容量パッケージ)
RUN pip3 install --no-cache-dir \
    torch --extra-index-url https://download.pytorch.org/whl/cu124

WORKDIR /workspace

# 起動コマンド（Jupyter Server / Notebook 双方のオリジン許可に対応）
CMD ["jupyter", "notebook", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--ServerApp.allow_origin='https://colab.research.google.com'", \
     "--NotebookApp.allow_origin='https://colab.research.google.com'", \
     "--ServerApp.port_retries=0", \
     "--NotebookApp.port_retries=0"]
EOF

echo "[+] Dockerイメージをビルドしています (キャッシュを利用): ${IMAGE_NAME}..."
DOCKER_BUILDKIT=1 docker build -f "${DOCKERFILE_PATH}" -t "${IMAGE_NAME}" .

if [[ "$(docker ps -aq -f name="^${CONTAINER_NAME}$")" ]]; then
    echo "[*] 既存コンテナを削除中..."
    docker rm -f "${CONTAINER_NAME}" > /dev/null
fi

echo "[+] コンテナを起動中..."
docker run -d \
    --name "${CONTAINER_NAME}" \
    --gpus all \
    -p "${HOST_PORT}:8888" \
    -v "${WORK_DIR}:/workspace" \
    "${IMAGE_NAME}" > /dev/null

echo "[+] トークン取得待機中..."
TOKEN=""
for i in {1..30}; do
    LOGS=$(docker logs "${CONTAINER_NAME}" 2>&1 || true)
    if echo "${LOGS}" | grep -q "token="; then
        TOKEN=$(echo "${LOGS}" | grep -o 'token=[a-zA-Z0-9]*' | head -n 1)
        break
    fi
    sleep 1
done

if [[ -z "${TOKEN}" ]]; then
    echo "[-] トークンの自動取得に失敗しました。ログを確認してください:"
    echo "    docker logs ${CONTAINER_NAME}"
    exit 1
fi

echo "=================================================================="
echo " Google Colab ローカルランタイムの準備が完了しました"
echo "=================================================================="
echo "Colabの「ローカル ランタイムに接続」に入力するURL:"
echo "http://localhost:${HOST_PORT}/?${TOKEN}"
echo ""
echo "マウントディレクトリ: ${WORK_DIR}"
echo "コンテナ停止: docker stop ${CONTAINER_NAME}"
echo "=================================================================="
