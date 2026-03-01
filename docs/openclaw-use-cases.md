# OpenClaw 使用场景配置指南

基于研究和实际配置经验，整理出实用的 OpenClaw 使用场景。

## 已配置的场景

### ✅ 场景1：每日IT新闻简报
**状态**: 已运行（每天9:00）
**功能**: 自动搜集IT新闻并发送简报
**配置**: Cron任务 `daily-it-news`

### ✅ 场景2：每日任务回顾
**状态**: 已运行（每天18:00）
**功能**: 汇总当日事件和待办事项
**配置**: Cron任务 `daily-task-review`

### ✅ 场景3：系统健康监控
**状态**: 已运行（每周一10:00）
**功能**: 自动检查系统状态
**配置**: Cron任务 `weekly-system-check` + 脚本 `scripts/health-check.sh`

### ✅ 场景4：代码自动同步
**状态**: 已运行（每小时）
**功能**: 自动提交并推送代码变更
**配置**: Cron任务 `auto-git-sync` + 脚本 `scripts/auto-sync.sh`

### ✅ 场景5：延迟彩蛋调研
**状态**: 已配置（3月2日9:00执行）
**功能**: 定期调研 OpenClaw/Kimi 更新
**配置**: Cron任务 `delayed-surprise`

---

## 推荐配置的场景（待实施）

### 场景5：智能Heartbeat检查
**功能**: 每30分钟检查待办事项、系统状态  
**需要**: 完善 `HEARTBEAT.md` 检查清单  
**配置**: 已启用默认Heartbeat（30分钟间隔）

### 场景6：个人知识库管理
**功能**: 自动保存重要对话到笔记，支持向量搜索  
**需要**: 
- 安装 `rag-search` 或 `vector-memory` 技能
- 配置 Obsidian/Notion 集成
- 设置自动归档规则

### 场景7：邮件自动分类与摘要
**功能**: 自动分类邮件，生成摘要，提取待办  
**需要**:
- 邮件读取技能
- 配置邮件账户
- 设置分类规则

### 场景8：智能家居联动
**功能**: 通过消息控制智能家居设备  
**需要**:
- Home Assistant 技能
- 设备控制技能
- 自动化规则配置

---

## 配置最佳实践

### Heartbeat vs Cron 选择

| 场景 | 推荐机制 | 原因 |
|------|----------|------|
| 每30分钟检查收件箱 | Heartbeat | 可批量处理，上下文感知 |
| 每天早上9点发送报告 | Cron (isolated) | 精确时间控制 |
| 20分钟后提醒 | Cron (`--at`) | 一次性精确提醒 |
| 每周深度分析 | Cron (isolated) | 独立会话，可使用更强模型 |

### 安全建议
1. **独立运行环境**: 在专用设备/VPS上运行
2. **独立凭据**: 为 OpenClaw 创建独立的邮箱和账户
3. **定期安全审计**: 运行 `openclaw security audit --deep`
4. **最小权限原则**: 只授予必要的读写权限

### 技能安装
```bash
# 基础工具
npx clawhub@latest install brave-search

# 开发相关
npx clawhub@latest install github docker-ctl

# 通信相关
npx clawhub@latest install telegram-bot

# 文档处理
npx clawhub@latest install pdf docx
```

---

## 当前系统状态

**运行中的定时任务**:
- `daily-it-news`: 每天 9:00
- `daily-task-review`: 每天 18:00
- `weekly-system-check`: 每周一 10:00
- `auto-git-sync`: 每小时
- `delayed-surprise`: 3月2日 9:00

**Heartbeat**: 默认30分钟间隔，检查 `HEARTBEAT.md`

**已安装技能**: 10+ 个（包括飞书文档、云盘、权限管理等）

---

## 技术架构

```
OpenClaw Gateway
├── 定时任务层 (Cron)
│   ├── daily-it-news (每日9:00)
│   ├── daily-task-review (每日18:00)
│   ├── weekly-system-check (每周一10:00)
│   ├── auto-git-sync (每小时)
│   └── delayed-surprise (3月2日)
│
├── 心跳检查层 (Heartbeat)
│   └── 每30分钟检查HEARTBEAT.md
│
├── 技能层 (Skills)
│   ├── feishu-doc (飞书文档)
│   ├── feishu-drive (飞书云盘)
│   └── feishu-wiki (知识库)
│
└── 子代理层 (Subagents)
    └── 并行任务处理
```

## 飞书集成能力

当前已激活的飞书技能：
1. **feishu-doc** - 读取和编辑飞书文档
2. **feishu-drive** - 管理飞书云盘文件
3. **feishu-wiki** - 知识库导航

使用方法：在飞书中直接发送文档链接或相关指令即可激活。

## 文档和脚本

已创建的文档：
- `docs/openclaw-use-cases.md` - 使用场景总览
- `docs/task-management-system.md` - 任务管理系统设计
- `docs/subagent-system.md` - 子代理分发系统设计
- `docs/automation-workflow.md` - 自动化工作流设计

已创建的脚本：
- `scripts/health-check.sh` - 系统健康检查
- `scripts/auto-sync.sh` - Git自动同步
- `scripts/heartbeat-check.sh` - 自动化心跳检查

---

*最后更新: 2026-03-01*
