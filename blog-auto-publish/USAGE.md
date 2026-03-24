# 📖 使用指南 (Usage Guide)

## 日常发布流程

### 方式一：发送 Markdown 文件（推荐）

直接将 `.md` 文件发送给敲敲，敲敲会自动处理：

```
你：帮我发布这篇博客 [上传文件: my-article.md]
敲敲：收到，我来处理...
      - 标题：xxx
      - 标签：xxx
      - 分类：xxx
      确认发布吗？
你：确认
敲敲：已发布！链接：https://xxx.github.io/posts/my-article/
```

### 方式二：直接粘贴内容

```
你：帮我发一篇博客，标题是"xxx"，内容如下：
    （粘贴 Markdown 内容）
敲敲：好的，我来整理格式并发布...
```

### 方式三：口述想法

```
你：帮我写一篇关于 Docker 入门的博客
敲敲：好的，我先帮你写好内容，你确认后再发布
```

---

## 敲敲自动处理的内容

当你发送 Markdown 文件时，敲敲会自动：

### 1. Frontmatter 处理

**如果文件已有 frontmatter：**
- 验证格式是否正确
- 补全缺失的必要字段（date、draft 等）
- 标准化标签和分类

**如果文件没有 frontmatter：**
- 从文件名或内容中提取标题
- 自动生成日期
- 设置 `draft: false`
- 根据内容推断标签和分类

### 2. 文件名处理

- 转换为 URL 友好的文件名
- 中文标题转拼音或英文 slug
- 确保文件名唯一（避免冲突）

示例：
```
"我的第一篇博客.md" → "2025-03-25-my-first-post.md"
"Docker入门教程.md" → "2025-03-25-docker-getting-started.md"
```

### 3. 图片处理

- 检测 Markdown 中的图片引用
- 将图片复制到 `static/images/` 目录
- 更新图片路径为绝对路径
- 压缩大图片（可选）

### 4. 内容优化

- 修复常见的 Markdown 格式问题
- 确保代码块有语言标识
- 检查链接有效性
- 生成摘要（如果没有提供）

---

## 博客文件格式规范

### 标准 Hugo 文章格式

```markdown
---
title: "文章标题"
date: 2025-03-25T12:00:00+08:00
lastmod: 2025-03-25T12:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["分类名"]
summary: "简短摘要，显示在文章列表中"
description: "SEO 描述，用于搜索引擎"
author: "无名"
cover:
  image: "/images/cover.jpg"
  alt: "封面图片"
  caption: "图片说明"
  relative: false
---

文章正文内容...

## 二级标题

正文段落...

### 三级标题

- 列表项 1
- 列表项 2

> 引用文本

```python
代码块
```

![图片说明](/images/example.png)

[链接文字](https://example.com)
```

### 简化格式（也支持）

如果你不想写 frontmatter，直接发纯 Markdown 也行：

```markdown
# 文章标题

文章内容...
```

敲敲会自动补全所有 frontmatter 信息。

---

## 图片使用指南

### 图片存放位置

```
blog-repo/
├── static/
│   └── images/
│       ├── posts/           # 文章配图
│       │   ├── docker-01.png
│       │   └── docker-02.png
│       └── covers/          # 封面图片
│           └── docker-cover.jpg
└── content/
    └── posts/
        └── docker-guide.md
```

### 在 Markdown 中引用图片

```markdown
<!-- 封面图片（在 frontmatter 中） -->
cover:
  image: "/images/covers/docker-cover.jpg"

<!-- 正文中的图片 -->
![Docker 架构图](/images/posts/docker-01.png)
```

### 支持的图片格式

- JPG / JPEG
- PNG
- GIF
- WebP（推荐，体积更小）
- SVG

### 图片命名规范

- 使用小写字母、数字、连字符
- 避免中文和空格
- 建议格式：`<文章slug>-<序号>.<格式>`

---

## 标签和分类体系

### 建议的分类

| 分类 | 说明 |
|------|------|
| `技术` | 编程、开发、工具 |
| `生活` | 随笔、感悟、日常 |
| `教程` | 系列教程、入门指南 |
| `读书` | 书评、读书笔记 |
| `项目` | 项目记录、开源项目 |

### 常用标签

```
# 编程语言
Python, JavaScript, Go, Rust, TypeScript

# 技术
Docker, Kubernetes, Linux, Git, CI/CD, API

# 框架
React, Vue, Hugo, Next.js, FastAPI

# 其他
效率工具, 开源, AI, 数据库, 网络
```

> 💡 标签和分类可以自由定义，以上仅为建议。

---

## 常用操作命令

### 本地预览

```bash
cd blog-repo
hugo server -D    # -D 参数会显示 draft 文章
```

### 新建文章

```bash
hugo new posts/my-new-post.md
```

### 构建静态文件

```bash
hugo              # 输出到 public/ 目录
```

### 查看草稿列表

```bash
rg "draft: true" content/posts/
```

---

## 发布检查清单

敲敲在发布前会检查以下项目：

- [ ] Frontmatter 格式正确
- [ ] `draft: false`（确保不是草稿）
- [ ] 日期格式正确（ISO 8601）
- [ ] 图片路径正确
- [ ] 文件名 URL 友好
- [ ] 没有重复的文件名
- [ ] Markdown 格式无误
- [ ] 代码块有语言标识

---

## 更新已有文章

```
你：帮我更新 "Docker 入门" 那篇文章，把第三段改成...
敲敲：好的，已更新并重新发布。
```

## 删除文章

```
你：帮我删除 "旧文章" 那篇
敲敲：确认要删除 "旧文章" 吗？删除后无法恢复。
你：确认
敲敲：已删除并重新部署。
```

## 批量操作

```
你：帮我发布这 3 篇文章 [上传多个文件]
敲敲：收到 3 篇文章：
      1. xxx - 标签：技术，分类：教程
      2. yyy - 标签：生活，分类：随笔
      3. zzz - 标签：Python，分类：技术
      全部发布？
你：确认
敲敲：3 篇文章已全部发布！
```
