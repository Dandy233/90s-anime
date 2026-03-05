#!/bin/bash
# 批量下载动漫图片

cd /tmp/90s-anime/images

# 下载图片函数
download_img() {
    local name="$1"
    local filename="$2"
    
    # 使用 Wikipedia 或 Baidu Baike 图片
    case "$name" in
        "slamdunk")
            # 灌篮高手
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/d/db/Slam_Dunk_vol_1.jpg/220px-Slam_Dunk_vol_1.jpg"
            ;;
        "dragonballz")
            # 七龙珠
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/DBZ_vol_1.jpg/220px-DBZ_vol_1.jpg"
            ;;
        "onepiece")
            # 海贼王
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/9/90/One_Piece_Vol_1.jpg/220px-One_Piece_Vol_1.jpg"
            ;;
        "eva")
            # EVA
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/4/4c/Neon_Genesis_Evangelion_vol_1.jpg/220px-Neon_Genesis_Evangelion_vol_1.jpg"
            ;;
        "naruto")
            # 火影忍者
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/9/94/NarutoCoverTankobon1.jpg/220px-NarutoCoverTankobon1.jpg"
            ;;
        "bleach")
            # 死神
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/7/72/Bleach_cover_01.jpg/220px-Bleach_cover_01.jpg"
            ;;
        "saintseiya")
            # 圣斗士星矢
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/0/03/Saint_Seiya_vol_1.jpg/220px-Saint_Seiya_vol_1.jpg"
            ;;
        "yuyuhakusho")
            # 幽游白书
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/4/4a/YuYu_Hakusho_vol_1.jpg/220px-YuYu_Hakusho_vol_1.jpg"
            ;;
        "inuyasha")
            # 犬夜叉
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/2/2a/InuYasha_vol_1.jpg/220px-InuYasha_vol_1.jpg"
            ;;
        "hunterxhunter")
            # 全职猎人
            curl -sL -o "$filename" "https://upload.wikimedia.org/wikipedia/en/thumb/0/0f/Hunter_%C3%97_Hunter_vol_1.jpg/220px-Hunter_%C3%97_Hunter_vol_1.jpg"
            ;;
    esac
    
    if [ -f "$filename" ] && [ -s "$filename" ]; then
        echo "✅ 下载成功: $filename ($(stat -c%s "$filename") bytes)"
    else
        echo "❌ 下载失败: $filename"
    fi
}

# 下载图片
download_img "slamdunk" "灌篮高手.jpg"
download_img "dragonballz" "七龙珠Z.jpg"
download_img "onepiece" "海贼王.jpg"
download_img "eva" "新世纪福音战士EVA.jpg"
download_img "naruto" "火影忍者.jpg"
download_img "bleach" "死神.jpg"
download_img "saintseiya" "圣斗士星矢.jpg"
download_img "yuyuhakusho" "幽游白书.jpg"
download_img "inuyasha" "犬夜叉.jpg"
download_img "hunterxhunter" "全职猎人.jpg"

echo ""
echo "图片下载完成！"
ls -lh *.jpg 2>/dev/null | head -15
