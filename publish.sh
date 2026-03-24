#!/bin/bash
# 博客自动发布脚本
# 使用方法: bash publish.sh "文章标题" "文件路径"
# 示例: bash publish.sh "我的文章" ./my-article.md

set -e

# ===== 配置区域 =====
BLOG_REPO="/home/z/my-project/blog-repo"  # 博客仓库本地路径（按实际修改）
POSTS_DIR="content/posts"                 # 文章目录
IMAGES_DIR="static/images/posts"          # 图片目录

# ===== 参数检查 =====
if [ -z "$1" ]; then
    echo "❌ 用法: bash publish.sh \"文章标题\" [文件路径]"
    echo "   或直接: bash publish.sh [文件路径] (从文件名提取标题)"
    exit 1
fi

# 判断参数是文件路径还是标题
if [ -f "$1" ]; then
    FILE_PATH="$1"
    TITLE=$(basename "$FILE_PATH" .md | sed 's/-/ /g')
else
    TITLE="$1"
    FILE_PATH="$2"
fi

# ===== 生成文件名 =====
DATE=$(date +%Y-%m-%d)
SLUG=$(echo "$TITLE" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9\u4e00-\u9fff]/-/g' | \
    sed 's/--*/-/g' | \
    sed 's/^-//;s/-$//')
FILENAME="${DATE}-${SLUG}.md"

echo "📝 标题: $TITLE"
echo "📄 文件: $FILENAME"
echo ""

# ===== 处理文件内容 =====
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
    # 检查是否已有 frontmatter
    if head -1 "$FILE_PATH" | grep -q "^---"; then
        echo "✅ 文件已有 frontmatter，直接复制"
        cp "$FILE_PATH" "${BLOG_REPO}/${POSTS_DIR}/${FILENAME}"
    else
        echo "✏️ 添加 frontmatter..."
        cat > "${BLOG_REPO}/${POSTS_DIR}/${FILENAME}" << EOF
---
title: "${TITLE}"
date: ${DATE}T$(date +%H:%M:%S)+08:00
lastmod: ${DATE}T$(date +%H:%M:%S)+08:00
draft: false
tags: []
categories: []
summary: ""
---

$(cat "$FILE_PATH")
EOF
    fi
else
    echo "✏️ 创建空文章模板..."
    cat > "${BLOG_REPO}/${POSTS_DIR}/${FILENAME}" << EOF
---
title: "${TITLE}"
date: ${DATE}T$(date +%H:%M:%S)+08:00
lastmod: ${DATE}T$(date +%H:%M:%S)+08:00
draft: true
tags: []
categories: []
summary: ""
---

在这里写你的文章内容...
EOF
fi

echo ""
echo "✅ 文章已创建: ${BLOG_REPO}/${POSTS_DIR}/${FILENAME}"
echo ""
echo "下一步操作:"
echo "  1. 编辑文章内容（如需要）"
echo "  2. 运行以下命令发布:"
echo ""
echo "     cd ${BLOG_REPO}"
echo "     git add ."
echo "     git commit -m \"feat: 发布 ${TITLE}\""
echo "     git push origin main"
echo ""
