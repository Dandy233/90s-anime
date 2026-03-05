#!/usr/bin/env python3
import re
import sys

def process_readme(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 找到所有表格并添加图片列
    lines = content.split('\n')
    result = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # 检测表格头部
        if line.startswith('| 看过 | 收藏 | 作品名称'):
            # 添加新的表头列
            new_header = '| 看过 | 收藏 | 海报 | 作品名称 | 年份 | 简介 | 经典度 |'
            result.append(new_header)
            
            # 处理分隔行
            i += 1
            if i < len(lines) and lines[i].startswith('|:--:'):
                new_sep = '|:--:|:--:|:---:|:---------|------|------|:------:|'
                result.append(new_sep)
                i += 1
            
            # 处理数据行，直到遇到空行或新标题
            while i < len(lines) and lines[i].startswith('| [') or lines[i].startswith('|  [') or lines[i].startswith('|[ ]'):
                # 解析当前行
                row = lines[i]
                # 提取作品名称
                match = re.search(r'\*\*([^*]+)\*\*', row)
                if match:
                    anime_name = match.group(1)
                    # 生成图片文件名（简化）
                    filename = anime_name.replace(' ', '').replace('(', '').replace(')', '').replace('&', '')[:20] + '.jpg'
                    
                    # 构建新行: 在看 | 收藏 | 海报 | 作品... 
                    # 原行: | [ ] | [ ] | **作品** | ...
                    # 新行: | [ ] | [ ] | ![海报](images/filename) | **作品** | ...
                    new_row = row.replace('| [ ] | [ ] |', f'| [ ] | [ ] | ![{anime_name}](images/{filename}) |', 1)
                    result.append(new_row)
                else:
                    result.append(row)
                i += 1
        else:
            result.append(line)
            i += 1
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(result))
    
    print(f"处理完成，输出到: {output_file}")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.md> <output.md>")
        sys.exit(1)
    
    process_readme(sys.argv[1], sys.argv[2])
