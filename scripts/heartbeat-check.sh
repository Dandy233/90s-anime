#!/bin/bash
# 自动化心跳检查脚本
# 每30分钟运行一次，检查系统状态并记录

LOG_FILE="/root/.openclaw/workspace/memory/heartbeat-$(date +%Y-%m-%d).log"

echo "=== Heartbeat Check $(date) ===" >> "$LOG_FILE"

# 1. 检查 Gateway 状态
echo "[1/4] Gateway 状态..." >> "$LOG_FILE"
pgrep -a openclaw-gateway | head -1 >> "$LOG_FILE" 2>&1 || echo "Gateway 未运行" >> "$LOG_FILE"

# 2. 检查定时任务
echo "" >> "$LOG_FILE"
echo "[2/4] 定时任务状态..." >> "$LOG_FILE"
openclaw cron list 2>/dev/null | grep -E "(error|failed)" >> "$LOG_FILE" || echo "所有任务正常" >> "$LOG_FILE"

# 3. 检查磁盘空间
echo "" >> "$LOG_FILE"
echo "[3/4] 磁盘空间..." >> "$LOG_FILE"
df -h /root/.openclaw | tail -1 >> "$LOG_FILE"

# 4. 检查 Git 状态
echo "" >> "$LOG_FILE"
echo "[4/4] Git 状态..." >> "$LOG_FILE"
cd /root/.openclaw/workspace
git status --short >> "$LOG_FILE" 2>&1 || echo "无法获取 Git 状态" >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
echo "=== 检查完成 $(date) ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 只保留最近7天的日志
find /root/.openclaw/workspace/memory/ -name "heartbeat-*.log" -mtime +7 -delete 2>/dev/null
