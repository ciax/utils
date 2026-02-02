#!/bin/bash
#Description: システム全体のDocker管理用
#Required Packages: docker
#alias ds
show_help() {
    echo "Docker System Management"
    echo "Usage: docker-sys [command]"
    echo
    echo "Commands:"
    grep -E '^\s+\w+\).*#' "$0" | sed -e 's/)/ /' -e 's/#/  -/'
}

case "$1" in
    ps)       # 起動中の全コンテナを表示
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
        ;;
    images)   # 全イメージを表示
        docker images
        ;;
    ip)       # 全コンテナのIPアドレス一覧
        docker inspect -f '{{.Name}} -> {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q)
        ;;
    stats)    # リソース使用状況 (CPU/メモリ)
        docker stats --no-stream
        ;;
    clean)    # 未使用のリソース(イメージ/コンテナ/ネットワーク)を一括削除
        echo "Cleaning unused resources..."
        docker system prune -f
        ;;
    purge)    # 【注意】停止中のコンテナ・全イメージ・全ボリュームを完全抹消
        echo "WARNING: Purging EVERYTHING..."
        docker system prune -af --volumes
        ;;
    *)
        show_help
        ;;
esac
