#!/usr/bin/env bash
# 一次性安装:把 auto-deploy.sh 装到 /root,并写入 root crontab(每 2 分钟检查一次)。
# 用法(控制台,root):  sudo bash /var/www/backtap-website/deploy/install-autodeploy.sh
set -euo pipefail

REPO="arise130315/backtap-website"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="/root/auto-deploy.sh"
INTERVAL="*/2 * * * *"   # 每 2 分钟

if [ "$(id -u)" -ne 0 ]; then
  echo "请用 root 运行:sudo bash $0"
  exit 1
fi

# 1. 安装脚本
install -m 755 "$SRC_DIR/auto-deploy.sh" "$DEST"
echo "✅ 已安装 $DEST"

# 2. 写入 crontab(先去重,避免重复添加)
CRON_LINE="$INTERVAL /bin/bash $DEST"
( crontab -l 2>/dev/null | grep -vF "auto-deploy.sh" ; echo "$CRON_LINE" ) | crontab -
echo "✅ 已写入 root crontab:"
crontab -l | grep "auto-deploy.sh" | sed 's/^/    /'

# 3. 初始化已部署 SHA = 当前远端,避免装完立刻重复部署一次
REMOTE_SHA=$(git ls-remote "https://github.com/${REPO}.git" refs/heads/main 2>/dev/null | awk '{print $1}')
if [ -n "$REMOTE_SHA" ]; then
  echo "$REMOTE_SHA" > /root/.backtap-deployed-sha
  echo "✅ 已记录当前已部署版本:${REMOTE_SHA:0:7}"
else
  echo "⚠️  获取远端 SHA 失败,首个 cron 周期会自动拉取一次当前 main(无害)"
fi

# 4. 确保 crond 在运行
systemctl enable --now crond 2>/dev/null || systemctl enable --now cron 2>/dev/null || true

echo ""
echo "🎉 自动部署已启用。今后只需 git push 到 main,约 2 分钟内自动上线。"
echo "   日志:tail -f /var/log/backtap-autodeploy.log"
echo "   查看定时任务:sudo crontab -l"
echo "   停用:sudo crontab -l | grep -v auto-deploy.sh | sudo crontab -"
