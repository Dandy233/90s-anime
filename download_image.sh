#!/bin/bash
# 下载动漫海报图片脚本

ANIME_NAME="$1"
OUTPUT_FILE="$2"

if [ -z "$ANIME_NAME" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Usage: $0 <anime_name> <output_file>"
    exit 1
fi

# 使用Bing图片搜索获取图片URL
ENCODED_NAME=$(echo "$ANIME_NAME" | sed 's/ /+/g')
SEARCH_URL="https://www.bing.com/images/search?q=${ENCODED_NAME}+动漫+海报"

# 尝试下载图片
echo "搜索: $ANIME_NAME"

# 使用curl获取搜索结果HTML，然后提取第一个图片URL
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"

# 获取图片URL
IMG_URL=$(curl -s -A "$USER_AGENT" "$SEARCH_URL" | \
    grep -oP 'https://[^"]+\.(jpg|jpeg|png)' | \
    grep -E '(th|mm\.bing|hbimg|alicdn)' | \
    head -1)

if [ -n "$IMG_URL" ]; then
    echo "找到图片: $IMG_URL"
    curl -s -L -A "$USER_AGENT" "$IMG_URL" -o "$OUTPUT_FILE" --max-time 15
    
    # 检查文件大小，如果太小可能是错误页面
    FILE_SIZE=$(stat -c%s "$OUTPUT_FILE" 2>/dev/null || echo 0)
    if [ "$FILE_SIZE" -lt 1000 ]; then
        echo "图片太小，可能下载失败: $FILE_SIZE bytes"
        rm -f "$OUTPUT_FILE"
        exit 1
    fi
    
    echo "下载成功: $OUTPUT_FILE (${FILE_SIZE} bytes)"
else
    echo "未找到图片"
    exit 1
fi
