# 技能使用报告

## 当前状态
- **已安装**: 10个技能
- **可用**: 53个技能
- **来源**: openclaw-extra, openclaw-bundled, openclaw-managed

## 已安装技能清单

| 技能 | 状态 | 用途 | 使用频率 |
|------|------|------|----------|
| feishu-doc | ✅ ready | 飞书文档读写 | 高 |
| feishu-drive | ✅ ready | 飞书云盘管理 | 中 |
| feishu-perm | ✅ ready | 飞书权限管理 | 低 |
| feishu-wiki | ✅ ready | 飞书知识库 | 低 |
| skill-creator | ✅ ready | 创建技能 | 低 |
| tmux | ✅ ready | 远程控制tmux | 未使用 |
| weather | ✅ ready | 天气查询 | 未使用 |
| channels-setup | ✅ ready | 渠道配置指南 | 已使用 |
| github | ✅ ready | GitHub操作 | 中 |
| healthcheck | ✅ ready | 系统安全检查 | 未使用 |

## 缺失但可能有用的技能

| 技能 | 用途 | 建议 |
|------|------|------|
| summarize | 文章/视频摘要 | 可考虑安装 |
| browser | 浏览器控制 | 已内置 |
| web_search | 网络搜索 | 已内置 |

## 安全评估

基于 ClawHavoc 事件（2026年2月发现341个恶意技能）：

- ✅ 当前所有技能均来自官方源（openclaw-extra/bundled/managed）
- ✅ 无第三方未知来源技能
- ✅ 建议定期检查 `openclaw security audit`

## 建议

1. **保留**: feishu-doc/drive（核心工作流）
2. **评估**: tmux、weather（当前未使用，可考虑卸载）
3. **关注**: summarize（可能对新闻简报有用）

---
*生成时间: 2026-03-01*
