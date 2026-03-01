#!/bin/bash
# 系统健康检查脚本
# 由 Kimi Claw 自动生成

echo "=== OpenClaw 系统健康检查 ==="
echo "时间: $(date)"
echo ""

echo "--- 磁盘空间 ---"
df -h /root/.openclaw | tail -1

echo ""
echo "--- Gateway 状态 ---"
pgrep -a openclaw-gateway | head -1 || echo "Gateway 未运行"

echo ""
echo "--- 会话文件大小 ---"
du -sh /root/.openclaw/agents/main/sessions/ 2>/dev/null || echo "无法获取"

echo ""
echo "--- 最近日志 ---"
tail -5 /tmp/openclaw/openclaw-$(date +%Y-%m-%d).log 2>/dev/null || echo "无日志"

echo ""
echo "=== 检查完成 ==="
