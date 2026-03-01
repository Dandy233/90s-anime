# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## 当前配置

### 定时任务（5个）
- daily-it-news: 每天 9:00 发送 IT 新闻简报
- daily-task-review: 每天 18:00 任务回顾日报
- weekly-system-check: 每周一 10:00 系统健康检查
- auto-git-sync: 每小时自动 Git 同步
- delayed-surprise: 2026-03-02 9:00 知识更新调研

### 脚本
- scripts/health-check.sh: 系统健康检查脚本
- scripts/auto-sync.sh: Git 自动同步脚本

### 目录结构
- memory/: 每日日志和长期记忆
- diary/: 私人日记
- scripts/: 自动化脚本
- archive/: 归档文件（大会话文件等）
