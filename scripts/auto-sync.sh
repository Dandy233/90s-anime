#!/bin/bash
# Git 自动同步脚本
# 每小时检查一次，如有变更则自动提交推送

REPO_DIR="/root/.openclaw/workspace"
cd "$REPO_DIR" || exit 1

# 检查是否有变更
if [ -z "$(git status --porcelain)" ]; then
    exit 0
fi

# 添加所有变更
git add -A

# 生成提交信息
CHANGES=$(git diff --cached --stat | tail -1)
COMMIT_MSG="Auto-sync: $(date '+%Y-%m-%d %H:%M') - ${CHANGES}"

# 提交并推送
git commit -m "$COMMIT_MSG"
git push origin main 2>/dev/null

echo "Synced at $(date)"
