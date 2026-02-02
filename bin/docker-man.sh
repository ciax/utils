#!/bin/bash
#Description: docker management
#alias dm
# --- 設定 ---
COMPOSE_FILE="docker-compose.yml"
EDITOR=${EDITOR:-vi}

# --- 自己文書化ヘルプ表示 ---
show_help() {
    echo "Project Local Management (Compose based)"
    echo "Usage: docker-man [command]"
    echo ""
    echo "Commands:"
    # 行頭にスペースがあり、括弧で終わるパターンを探して # 以降を説明として表示
    grep -E '^\s+\w+\).*#' "$0" | sed -e 's/)/ /' -e 's/#/  -/'
}

# --- エラーハンドリング ---
handle_error() {
    if [ $? -ne 0 ]; then
        echo "------------------------------------------------"
        echo "Error: コマンドが失敗しました。"
        echo "設定ファイル ${COMPOSE_FILE} を確認しますか？ (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            $EDITOR "$COMPOSE_FILE"
        fi
        exit 1
    fi
}

# --- 設定ファイル存在チェック ---
check_file() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo "Error: ${COMPOSE_FILE} が見つかりません。"
        exit 1
    fi
}

# --- メイン処理 ---
case "$1" in
    up)       # サービスをビルドしてバックグラウンド起動
        check_file
        docker compose up -d --build || handle_error
        ;;
    stop)     # コンテナを停止 (削除はしない)
        docker compose stop
        ;;
    down)     # コンテナを停止し、ネットワークと併せて削除
        docker compose down
        ;;
    logs)     # リアルタイムでログを表示
        docker compose logs -f
        ;;
    sh)       # サービス内に入る (例: ./manage.sh sh app)
        check_file
        # 第2引数がなければ1番目のサービスを自動選択
        SERVICE=${2:-$(docker compose ps --format "{{.Service}}" | head -n 1)}
        docker compose exec "$SERVICE" /bin/bash || docker compose exec "$SERVICE" /bin/sh
        ;;
    build)    # キャッシュを使わずにイメージを再生成
        check_file
        docker compose build --no-cache || handle_error
        ;;
    *)
        show_help
        ;;
esac
