#!/usr/bin/env python3
import re
import json

def extract_anime_from_html(html_file):
    """从index.html提取动漫数据"""
    with open(html_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 提取animeData对象
    match = re.search(r'const animeData = ({.*?});', content, re.DOTALL)
    if not match:
        print("未找到animeData")
        return []
    
    try:
        data_str = match.group(1)
        # 处理JavaScript对象格式转换为JSON
        # 先尝试直接解析
        anime_data_obj = json.loads(data_str)
        
        # 合并所有地区的数据
        all_anime = []
        for region, items in anime_data_obj.items():
            for item in items:
                item['region'] = region
                all_anime.append(item)
        return all_anime
    except json.JSONDecodeError as e:
        print(f"JSON解析错误: {e}")
        return []

def generate_readme(anime_data, output_file):
    """生成README.md"""
    
    # 按地区分类
    regions = {'japan': '日本动画', 'china': '国产动画', 'us': '欧美动画'}
    region_titles = {
        'japan': '一、日本动画篇',
        'china': '二、国产动画篇', 
        'us': '三、欧美动画篇'
    }
    
    lines = [
        "# 90后经典动漫收藏大全",
        "",
        "> 献给所有在动画陪伴下成长的90后一代",
        "",
        "🌐 **在线访问**: [https://dandy233.github.io/90s-anime/](https://dandy233.github.io/90s-anime/)",
        "",
        "---",
        "",
        "## 使用说明",
        "",
        "点击作品名称后的 **百科** 链接查看详细信息。",
        "",
        "在 GitHub 上浏览时，可以手动编辑方括号来标记：",
        "- `[x]` 表示已看过",
        "- `[x]` 表示已收藏",
        "",
        "---",
        "",
    ]
    
    # 统计
    total = len(anime_data)
    lines.append(f"## 统计数据")
    lines.append("")
    lines.append(f"**总计: {total}部作品**")
    lines.append("")
    
    for region_key, region_name in regions.items():
        count = len([a for a in anime_data if a.get('region') == region_key])
        lines.append(f"- {region_name}: {count}部")
    lines.append("")
    lines.append("---")
    lines.append("")
    
    # 按地区输出
    for region_key in ['japan', 'china', 'us']:
        region_anime = [a for a in anime_data if a.get('region') == region_key]
        if not region_anime:
            continue
            
        lines.append(f"## {region_titles[region_key]}")
        lines.append("")
        
        # 按子分类分组
        categories = {}
        for anime in region_anime:
            cat = anime.get('category', '其他')
            if cat not in categories:
                categories[cat] = []
            categories[cat].append(anime)
        
        for category in sorted(categories.keys()):
            items = categories[category]
            lines.append(f"### {category}")
            lines.append("")
            lines.append("| 看过 | 收藏 | 海报 | 作品名称 | 年份 | 简介 | 经典度 |")
            lines.append("|:--:|:--:|:---:|:---------|------|------|:------:|")
            
            for anime in items:
                watched = "[x]" if anime.get('watched') else "[ ]"
                collected = "[x]" if anime.get('collected') else "[ ]"
                title = anime.get('title', '')
                year = anime.get('year', '')
                desc = anime.get('desc', '')
                rating_num = anime.get('rating', 4)
                rating = "⭐" * rating_num + "⭐" * (5-rating_num)
                
                # 生成图片文件名
                img_filename = title.replace(' ', '').replace('(', '').replace(')', '').replace('&', '').replace('&', '')[:30] + '.jpg'
                
                lines.append(f"| {watched} | {collected} | ![{title}](images/{img_filename}) | **{title}** | {year} | {desc} | {rating} |")
            
            lines.append("")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    
    print(f"✅ 生成完成: {output_file}")
    print(f"   共 {total} 部作品")

if __name__ == '__main__':
    anime_data = extract_anime_from_html('index.html')
    if anime_data:
        generate_readme(anime_data, 'README.md')
    else:
        print("❌ 未能提取数据")
