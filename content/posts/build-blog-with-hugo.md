---
title: "从零搭建 Hugo 博客：GitHub Pages + PaperMod 主题完整指南"
date: 2026-03-25T01:25:00+08:00
lastmod: 2026-03-25T01:25:00+08:00
draft: false
tags: ["Hugo", "博客", "GitHub Pages", "教程"]
categories: ["技术"]
summary: "记录从零开始搭建 Hugo 博客的完整过程，包括主题配置、GitHub Actions 自动部署等"
description: "详细记录使用 Hugo + PaperMod 主题搭建个人博客并部署到 GitHub Pages 的全过程"
---

## 前言

本文记录了我从零开始搭建这个博客的完整过程。技术栈如下：

| 组件 | 技术 | 说明 |
|------|------|------|
| 静态站点生成器 | Hugo | Go 语言编写，构建速度极快 |
| 博客主题 | PaperMod | 简洁美观，功能丰富 |
| 托管平台 | GitHub Pages | 免费托管，自定义域名支持 |
| 自动部署 | GitHub Actions | 推送代码自动构建部署 |

---

## 一、环境准备

### 1.1 安装 Hugo

```bash
# macOS
brew install hugo

# Ubuntu/Debian
sudo apt install hugo

# Windows (使用 Chocolatey)
choco install hugo-extended
```

### 1.2 验证安装

```bash
hugo version
# hugo v0.146.0+extended ...
```

> **注意**：PaperMod 主题要求 Hugo 版本 >= 0.146.0

---

## 二、创建项目

### 2.1 初始化 Hugo 站点

```bash
# 创建新站点
hugo new site openblog

# 进入项目目录
cd openblog
```

### 2.2 添加 PaperMod 主题

```bash
# 初始化 Git
git init

# 添加主题为子模块
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

### 2.3 配置主题

在 `hugo.yaml` 中添加：

```yaml
theme: "PaperMod"

params:
  homeInfoParams:
    Title: "我的博客"
    Content: "欢迎来到我的个人博客"
  socialIcons:
    - name: github
      url: "https://github.com/yourusername"

menu:
  main:
    - name: 首页
      url: /
      weight: 1
    - name: 归档
      url: /archives/
      weight: 5
    - name: 搜索
      url: /search/
      weight: 10
```

---

## 三、创建内容

### 3.1 创建第一篇文章

```bash
hugo new posts/my-first-post.md
```

### 3.2 文章格式

```markdown
---
title: "文章标题"
date: 2026-03-25T01:00:00+08:00
draft: false
tags: ["标签1", "标签2"]
categories: ["分类"]
summary: "文章摘要"
---

## 正文开始

这里是文章内容...
```

### 3.3 本地预览

```bash
hugo server -D
# 访问 http://localhost:1313
```

---

## 四、GitHub Pages 部署

### 4.1 创建 GitHub 仓库

1. 在 GitHub 创建新仓库，如 `openblog`
2. 仓库地址：`https://github.com/username/openblog`

### 4.2 配置 GitHub Actions

创建文件 `.github/workflows/deploy.yml`：

```yaml
name: Deploy Hugo to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.146.0
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb \
            https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb

      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4

      - name: Build with Hugo
        env:
          HUGO_ENVIRONMENT: production
        run: |
          hugo \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 4.3 推送代码

```bash
git add .
git commit -m "feat: 初始化 Hugo 博客"
git branch -M main
git remote add origin https://github.com/username/openblog.git
git push -u origin main
```

### 4.4 启用 GitHub Pages

1. 进入仓库 **Settings** → **Pages**
2. **Source** 选择 **GitHub Actions**
3. 点击 **Save**

---

## 五、遇到的问题及解决方案

### 5.1 Hugo 版本不兼容

**问题**：PaperMod 主题要求 Hugo >= 0.146.0，但 GitHub Actions 默认使用旧版本

**解决**：在 workflow 中指定 `HUGO_VERSION: 0.146.0`

### 5.2 GitHub Pages 404 错误

**问题**：部署后访问显示 404

**解决**：需要在仓库设置中手动启用 GitHub Pages，并选择 GitHub Actions 作为 Source

### 5.3 子模块未正确克隆

**问题**：主题文件夹为空

**解决**：使用 `git submodule update --init --recursive` 或在 workflow 中添加 `submodules: recursive`

---

## 六、总结

通过以上步骤，我们成功搭建了一个基于 Hugo + PaperMod 的个人博客，并实现了：

- ✅ GitHub Pages 免费托管
- ✅ GitHub Actions 自动部署
- ✅ Markdown 写作体验
- ✅ 响应式设计，移动端友好
- ✅ 支持搜索、归档、标签等功能

后续可以继续优化：

- 添加评论系统（如 giscus、utterances）
- 配置自定义域名
- 添加 Google Analytics
- 优化 SEO 设置

---

## 参考链接

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [PaperMod 主题文档](https://adityatelange.github.io/hugo-PaperMod/)
- [GitHub Pages 文档](https://docs.github.com/zh/pages)
