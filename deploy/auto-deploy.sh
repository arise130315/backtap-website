#!/usr/bin/env bash
# 自动部署:检查 GitHub main 是否有新提交,有则调用 update-site.sh 拉取更新。
# 由 root 的 crontab 每隔几分钟调用一次。安装见同目录 install-autodeploy.sh。
set -euo pipefail

REPO="arise130315/backtap-website"
BRANCH="main"
SHA_FILE="/root/.backtap-deployed-sha"
LOG="/var/log/backtap-autodeploy.log"
UPDATE_SCRIPT="/root/update-site.sh"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG"; }

# 只查引用,不下载代码树,轻量且不易受弱网影响
REMOTE_SHA=$(git ls-remote "https://github.com/${REPO}.git" "refs/heads/${BRANCH}" 2>/dev/null | awk '{print $1}')
if [ -z "$REMOTE_SHA" ]; then
  log "WARN: 获取远端 SHA 失败(网络问题?),本次跳过"
  exit 0
fi

LOCAL_SHA=""
[ -f "$SHA_FILE" ] && LOCAL_SHA=$(cat "$SHA_FILE")

# 无变化:静默退出,不写日志、不下载
[ "$REMOTE_SHA" = "$LOCAL_SHA" ] && exit 0

log "检测到新提交 ${LOCAL_SHA:0:7}(首次为空) -> ${REMOTE_SHA:0:7},开始部署..."
if bash "$UPDATE_SCRIPT" >> "$LOG" 2>&1; then
  echo "$REMOTE_SHA" > "$SHA_FILE"
  log "✅ 部署完成 ${REMOTE_SHA:0:7}"
else
  log "❌ 部署失败,保留旧 SHA,下个周期重试"
  exit 1
fi
