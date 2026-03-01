#!/bin/bash
# ============================================
# 动漫收藏数据导出工具
# anime-export.sh
# ============================================

# 配置
MARKDOWN_FILE="${1:-docs/90s-anime-collection-checklist.md}"
OUTPUT_DIR="./exports"
DATE=$(date +%Y%m%d)

# 颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 非TTY环境禁用颜色
if [[ ! -t 1 ]]; then
    GREEN=''
    BLUE=''
    YELLOW=''
    NC=''
fi

mkdir -p "$OUTPUT_DIR"

show_help() {
    echo -e "${BLUE}动漫收藏数据导出工具${NC}"
    echo ""
    echo "用法: $0 [格式] [输入文件]"
    echo ""
    echo "导出格式:"
    echo "  csv       导出为CSV表格（适合Excel分析）"
    echo "  json      导出为JSON（适合开发者）"
    echo "  html      导出为HTML网页（适合浏览器查看）"
    echo "  txt       导出为纯文本列表"
    echo "  markdown  导出纯净版Markdown"
    echo "  notion    导出为Notion导入格式"
    echo ""
    echo "示例:"
    echo "  $0 csv                          # 导出为CSV"
    echo "  $0 html my-checklist.md         # 导出指定文件为HTML"
}

# 导出为CSV
export_csv() {
    local output="$OUTPUT_DIR/anime_collection_$DATE.csv"
    
    echo -e "${BLUE}📊 正在导出为CSV格式...${NC}"
    
    # CSV 表头
    echo "看过,作品名称,年份,地区,评分" > "$output"
    
    # 提取表格数据并转换为CSV
    grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式\|→\|改为\|:-\|:--' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 6 ]]; then
            local check=$(echo "${cols[1]}" | xargs)
            local watched=$(echo "$check" | grep -q 'x' && echo "是" || echo "否")
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            local year=$(echo "${cols[3]}" | xargs)
            local rating=$(echo "${cols[5]}" | xargs)
            
            # 检测地区
            local region="未知"
            if [[ -n "$name" && -n "$year" ]]; then
                echo "\"$watched\",\"$name\",\"$year\",\"$region\",\"$rating\"" >> "$output"
            fi
        fi
    done
    
    echo -e "${GREEN}✅ CSV导出完成: $output${NC}"
}

# 导出为HTML
export_html() {
    local output="$OUTPUT_DIR/anime_collection_$DATE.html"
    
    echo -e "${BLUE}🌐 正在导出为HTML格式...${NC}"
    
    # 统计数据
    local watched=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[x\]' | grep -v '示例\|格式' | wc -l)
    local total=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式' | wc -l)
    [[ $total -eq 0 ]] && total=1
    local percentage=$((watched * 100 / total))
    
    cat > "$output" <>'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>90后经典动漫收藏 - 我的观看记录</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden; }
        .header { background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%); color: white; padding: 40px; text-align: center; }
        .header h1 { font-size: 2.5em; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0,0,0,0.2); }
        .stats-bar { display: flex; justify-content: space-around; padding: 30px; background: #f8f9fa; border-bottom: 1px solid #e9ecef; flex-wrap: wrap; }
        .stat-item { text-align: center; margin: 10px; }
        .stat-value { font-size: 2.5em; font-weight: bold; color: #667eea; }
        .stat-label { color: #6c757d; margin-top: 5px; }
        .progress-container { padding: 30px 40px; background: #fff; }
        .progress-bar { height: 30px; background: #e9ecef; border-radius: 15px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); border-radius: 15px; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; }
        .content { padding: 40px; }
        .section { margin-bottom: 40px; }
        .section-title { font-size: 1.5em; color: #333; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 3px solid #667eea; }
        .anime-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 15px; }
        .anime-card { background: #f8f9fa; border-radius: 12px; padding: 15px; border-left: 4px solid #dee2e6; }
        .anime-card.watched { border-left-color: #28a745; background: linear-gradient(135deg, #d4edda 0%, #f8f9fa 100%); }
        .anime-name { font-weight: bold; color: #333; margin-bottom: 5px; }
        .anime-meta { font-size: 0.9em; color: #6c757d; }
        .watched-badge { display: inline-block; background: #28a745; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.75em; margin-left: 8px; }
        .footer { text-align: center; padding: 20px; color: #6c757d; font-size: 0.9em; border-top: 1px solid #e9ecef; }
        @media print { body { background: white; } .container { box-shadow: none; } }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎌 90后经典动漫收藏 🎌</h1>
            <p>我的童年回忆与观看记录</p>
        </div>
        <div class="stats-bar">
            <div class="stat-item"><div class="stat-value">'$watched'</div><div class="stat-label">已观看</div></div>
            <div class="stat-item"><div class="stat-value">'$total'</div><div class="stat-label">总数</div></div>
            <div class="stat-item"><div class="stat-value">'${percentage}%'</div><div class="stat-label">完成度</div></div>
        </div>
        <div class="progress-container">
            <div class="progress-bar"><div class="progress-fill" style="width: '${percentage}%'">'${percentage}%'</div></div>
        </div>
        <div class="content">
EOF

    # 日本动画
    echo '<div class="section"><div class="section-title">🇯🇵 日本动画</div><div class="anime-list">' >> "$output"
    
    grep -A 300 '## 一、日本动画篇' "$MARKDOWN_FILE" | grep -E '^\|' | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式\|:-\|:--' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 6 ]]; then
            local check=$(echo "${cols[1]}" | xargs)
            local is_watched=""
            local badge=""
            if echo "$check" | grep -q 'x'; then
                is_watched="watched"
                badge='<span class="watched-badge">✓ 已看</span>'
            fi
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            local year=$(echo "${cols[3]}" | xargs)
            local rating=$(echo "${cols[5]}" | xargs | sed 's/⭐/★/g')
            
            if [[ -n "$name" ]]; then
                echo "<div class=\"anime-card $is_watched\"><div class=\"anime-name\">$name $badge</div><div class=\"anime-meta\">$year | $rating</div></div>" >> "$output"
            fi
        fi
    done
    
    echo '</div></div>' >> "$output"
    
    # 国产动画
    echo '<div class="section"><div class="section-title">🇨🇳 国产动画</div><div class="anime-list">' >> "$output"
    
    grep -A 100 '## 二、国产动画篇' "$MARKDOWN_FILE" | grep -E '^\|' | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式\|:-\|:--' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 6 ]]; then
            local check=$(echo "${cols[1]}" | xargs)
            local is_watched=""
            local badge=""
            if echo "$check" | grep -q 'x'; then
                is_watched="watched"
                badge='<span class="watched-badge">✓ 已看</span>'
            fi
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            local year=$(echo "${cols[3]}" | xargs)
            local rating=$(echo "${cols[5]}" | xargs | sed 's/⭐/★/g')
            
            if [[ -n "$name" ]]; then
                echo "<div class=\"anime-card $is_watched\"><div class=\"anime-name\">$name $badge</div><div class=\"anime-meta\">$year | $rating</div></div>" >> "$output"
            fi
        fi
    done
    
    echo '</div></div>' >> "$output"
    
    # 欧美动画
    echo '<div class="section"><div class="section-title">🇺🇸 欧美动画</div><div class="anime-list">' >> "$output"
    
    grep -A 100 '## 三、欧美动画篇' "$MARKDOWN_FILE" | grep -E '^\|' | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式\|:-\|:--' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 6 ]]; then
            local check=$(echo "${cols[1]}" | xargs)
            local is_watched=""
            local badge=""
            if echo "$check" | grep -q 'x'; then
                is_watched="watched"
                badge='<span class="watched-badge">✓ 已看</span>'
            fi
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            local year=$(echo "${cols[3]}" | xargs)
            local rating=$(echo "${cols[5]}" | xargs | sed 's/⭐/★/g')
            
            if [[ -n "$name" ]]; then
                echo "<div class=\"anime-card $is_watched\"><div class=\"anime-name\">$name $badge</div><div class=\"anime-meta\">$year | $rating</div></div>" >> "$output"
            fi
        fi
    done
    
    echo '</div></div>' >> "$output"
    
    # Footer
    cat >> "$output" << EOF
        </div>
        <div class="footer">
            <p>生成时间: $(date '+%Y年%m月%d日') | 90后经典动漫收藏</p>
            <p>"愿你走出半生，归来仍是少年。"</p>
        </div>
    </div>
</body>
</html>
EOF

    echo -e "${GREEN}✅ HTML导出完成: $output${NC}"
    echo -e "${BLUE}💡 提示: 用浏览器打开即可查看，按 Ctrl+P 可打印为PDF${NC}"
}

# 导出为Notion格式
export_notion() {
    local output="$OUTPUT_DIR/anime_collection_notion_$DATE.md"
    
    echo -e "${BLUE}📝 正在导出为Notion格式...${NC}"
    
    cat > "$output" << EOF
# 90后经典动漫收藏 - Notion导入版

> 💡 **导入说明**: 复制以下内容到Notion页面即可
> 格式已优化为Notion数据库兼容格式

| 状态 | 作品名称 | 年份 | 地区 | 评分 | 备注 |
|------|----------|------|------|------|------|
EOF

    # 提取所有动画数据
    grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式\|:-\|:--' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 6 ]]; then
            local check=$(echo "${cols[1]}" | xargs)
            local status=$(echo "$check" | grep -q 'x' && echo "✅ 已看" || echo "⬜ 未看")
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            local year=$(echo "${cols[3]}" | xargs)
            local rating=$(echo "${cols[5]}" | xargs)
            
            # 检测地区
            local region="未知"
            if grep -q "$name" <<< "$(grep -A 300 '## 一、日本动画篇' "$MARKDOWN_FILE")"; then
                region="日本"
            elif grep -q "$name" <<< "$(grep -A 100 '## 二、国产动画篇' "$MARKDOWN_FILE")"; then
                region="国产"
            elif grep -q "$name" <<< "$(grep -A 100 '## 三、欧美动画篇' "$MARKDOWN_FILE")"; then
                region="欧美"
            fi
            
            if [[ -n "$name" && -n "$year" ]]; then
                echo "| $status | $name | $year | $region | $rating | |" >> "$output"
            fi
        fi
    done
    
    echo "" >> "$output"
    echo "---" >> "$output"
    echo "" >> "$output"
    echo "## 📊 统计数据" >> "$output"
    echo "" >> "$output"
    
    local watched=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[x\]' | grep -v '示例\|格式' | wc -l)
    local total=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式' | wc -l)
    [[ $total -eq 0 ]] && total=1
    
    echo "- **已观看**: $watched 部" >> "$output"
    echo "- **总计**: $total 部" >> "$output"
    echo "- **完成度**: $((watched * 100 / total))%" >> "$output"
    
    echo -e "${GREEN}✅ Notion格式导出完成: $output${NC}"
    echo -e "${BLUE}💡 提示: 复制表格内容到Notion，可自动转换为数据库${NC}"
}

# 导出为纯文本列表
export_txt() {
    local output="$OUTPUT_DIR/anime_collection_$DATE.txt"
    
    echo -e "${BLUE}📝 正在导出为纯文本...${NC}"
    
    cat > "$output" << EOF
=====================================
   90后经典动漫收藏 - 观看清单
=====================================

EOF

    local watched_count=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[x\]' | grep -v '示例\|格式' | wc -l)
    local total=$(grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[[ x]\]' | grep -v '示例\|格式' | wc -l)
    
    echo "【已观看作品】($watched_count 部)" >> "$output"
    echo "" >> "$output"
    
    grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[x\]' | grep -v '示例\|格式' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 3 ]]; then
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            [[ -n "$name" ]] && echo "  ✓ $name" >> "$output"
        fi
    done
    
    echo "" >> "$output"
    echo "【待观看作品】" >> "$output"
    echo "" >> "$output"
    
    grep -E '^\|' "$MARKDOWN_FILE" | grep -E '^\|[^|]*\[ \]' | grep -v '示例\|格式' | while IFS='|' read -ra cols; do
        if [[ ${#cols[@]} -ge 3 ]]; then
            local name=$(echo "${cols[2]}" | sed 's/\[\[.*\]\]//g; s/\*\*//g' | xargs)
            [[ -n "$name" ]] && echo "  ○ $name" >> "$output"
        fi
    done
    
    echo "" >> "$output"
    echo "=====================================" >> "$output"
    echo "总计: $watched_count / $total 部 ($(awk "BEGIN {printf \"%.1f\", $watched_count * 100 / $total}"))%" >> "$output"
    echo "导出时间: $(date '+%Y-%m-%d %H:%M')" >> "$output"
    echo "=====================================" >> "$output"
    
    echo -e "${GREEN}✅ 文本导出完成: $output${NC}"
}

# 主程序
case "${1:-help}" in
    csv)
        export_csv
        ;;
    html)
        export_html
        ;;
    notion)
        export_notion
        ;;
    txt|text)
        export_txt
        ;;
    json)
        echo -e "${BLUE}📦 使用 anime-backup.sh export 导出JSON${NC}"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${YELLOW}未知格式: $1${NC}"
        show_help
        exit 1
        ;;
esac
