# 🚀 从零搭建指南 (Setup Guide)

本指南带你从零开始搭建博客自动发布系统。预计耗时 **30 分钟**。

---

## 前置条件

- 一个 [GitHub](https://github.com) 账号
- 基本的命令行操作能力（但大部分操作由敲敲代劳）
- （可选）自定义域名

---

## 第一步：创建 GitHub 仓库

### 1.1 创建仓库

在 GitHub 上创建一个新仓库：

- **仓库名**：`<你的GitHub用户名>.github.io`（这样可以直接用 `https://<用户名>.github.io` 访问）
  - 例如用户名是 `zhangsan`，则仓库名为 `zhangsan.github.io`
- **可见性**：Public（GitHub Pages 免费版要求公开仓库）
- **不要**勾选 README、.gitignore、License（后面我们手动创建）

> 💡 如果你不想用 `<用户名>.github.io` 这个仓库名，也可以用任意名字如 `my-blog`，但访问地址会变成 `https://<用户名>.github.io/my-blog`

### 1.2 本地克隆

```bash
git clone https://github.com/<你的用户名>/<你的用户名>.github.io.git
cd <你的用户名>.github.io
```

---

## 第二步：初始化 Hugo 项目

### 2.1 安装 Hugo

**macOS:**
```bash
brew install hugo
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install hugo
```

**Windows:**
```bash
choco install hugo-extended
# 或
winget install Hugo.Hugo.Extended
```

**验证安装：**
```bash
hugo version
```

> ⚠️ 建议安装 `hugo-extended` 版本以支持 SCSS。

### 2.2 初始化项目

```bash
hugo init .
```

这会生成基础的项目结构。

---

## 第三步：安装 PaperMod 主题

### 3.1 添加为 Git Submodule

```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
```

### 3.2 创建 Hugo 配置文件

创建 `hugo.yaml`（Hugo 推荐的新格式）：

```yaml
baseURL: https://<你的用户名>.github.io/
languageCode: zh-cn
defaultContentLanguage: zh
title: 无名的博客
theme: PaperMod

# 启用 emoji
enableEmoji: true

# 参数配置
params:
  author: 无名
  description: "个人博客 - 记录技术与生活"
  keywords: [Blog, 技术, 编程]
  defaultTheme: auto  # auto | light | dark
  ShowReadingTime: true
  ShowWordCount: true
  ShowBreadCrumbs: true
  ShowPostNavLinks: true
  ShowCodeCopyButtons: true
  ShowToc: true

  # 社交链接
  socialIcons:
    - name: github
      url: "https://github.com/<你的用户名>"
    # - name: twitter
    #   url: "https://twitter.com/<你的用户名>"
    # - name: email
    #   url: "mailto:<你的邮箱>"

  # 主页信息模式
  homeInfoParams:
    Title: "你好 👋"
    Content: "欢迎来到我的博客。这里记录我的技术探索和生活感悟。"

  # 封面图片设置
  cover:
    hidden: false
    hiddenInList: false
    hiddenInSingle: false

# 导航菜单
menu:
  main:
    - identifier: archives
      name: 归档
      url: /archives/
      weight: 10
    - identifier: search
      name: 搜索
      url: /search/
      weight: 20
    - identifier: tags
      name: 标签
      url: /tags/
      weight: 30
    - identifier: categories
      name: 分类
      url: /categories/
      weight: 40

# 搜索功能
outputs:
  home:
    - HTML
    - RSS
    - JSON  # 搜索需要

# Markdown 渲染配置
markup:
  highlight:
    noClasses: false
    codeFences: true
    guessSyntax: true
    lineNos: true
```

### 3.3 创建文章模板

创建 `archetypes/default.md`：

```markdown
---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
summary: ""
description: ""
---

```

---

## 第四步：配置 GitHub Actions 自动部署

### 4.1 创建部署工作流

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy Hugo to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:  # 允许手动触发

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
      HUGO_VERSION: 0.140.2
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb \
            https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
          sudo dpkg -i ${{ runner.temp }}/hugo.deb

      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0  # 读取所有历史以支持 .Lastmod

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5

      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: Asia/Shanghai
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

### 4.2 启用 GitHub Pages

1. 进入仓库 → **Settings** → **Pages**
2. **Source** 选择 **GitHub Actions**
3. 保存

---

## 第五步：创建第一篇文章并发布

### 5.1 创建文章

创建 `content/posts/hello-world.md`：

```markdown
---
title: "Hello World"
date: 2025-03-25T00:00:00+08:00
draft: false
tags: ["随笔"]
categories: ["生活"]
summary: "我的第一篇博客"
---

## 你好世界

这是我的第一篇博客文章，使用 Hugo + PaperMod 主题搭建。

### 为什么选择 Hugo？

- 构建速度快
- Markdown 原生支持
- 主题丰富
- 免费托管在 GitHub Pages

> 博客已上线！
```

### 5.2 本地预览（可选）

```bash
hugo server -D
```

浏览器打开 `http://localhost:1313` 预览。

### 5.3 提交并推送

```bash
git add .
git commit -m "feat: 初始化博客，发布第一篇文章"
git push origin main
```

### 5.4 等待部署

推送后 GitHub Actions 会自动构建部署，通常 1-2 分钟完成。

访问 `https://<你的用户名>.github.io` 查看你的博客！

---

## 第六步：配置敲敲自动发布（可选增强）

如果你想让敲敲（AI Agent）自动帮你发布博客，需要配置以下内容：

### 6.1 配置 Git 访问

在敲敲的工作环境中配置 Git：

```bash
git config --global user.name "无名"
git config --global user.email "<你的邮箱>"
```

### 6.2 配置 SSH Key 或 Token

**方式一：SSH Key（推荐）**
```bash
ssh-keygen -t ed25519 -C "<你的邮箱>"
# 将公钥添加到 GitHub → Settings → SSH and GPG keys → New SSH key
# 然后使用 SSH 地址克隆仓库
git remote set-url origin git@github.com:<用户名>/<用户名>.github.io.git
```

**方式二：Personal Access Token**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token，勾选 `repo` 权限
3. 使用 Token 作为密码进行 HTTPS 认证

### 6.3 克隆仓库到工作空间

```bash
cd /home/z/my-project/
git clone git@github.com:<用户名>/<用户名>.github.io.git blog-repo
```

配置完成后，你只需把 Markdown 文件发给敲敲，敲敲会：
1. 处理文件格式和 frontmatter
2. 放入 `content/posts/` 目录
3. Git commit + push
4. GitHub Actions 自动部署

---

## （可选）绑定自定义域名

### 1. 配置 DNS

在你的域名 DNS 设置中添加：

```
CNAME  @  <用户名>.github.io
```

### 2. 在仓库中添加 CNAME 文件

创建 `static/CNAME` 文件，内容为你的域名：

```
yourdomain.com
```

### 3. 在 Hugo 配置中更新 baseURL

```yaml
baseURL: https://yourdomain.com/
```

### 4. 在 GitHub Pages 设置中填写自定义域名

Settings → Pages → Custom domain → 填写你的域名 → Save

---

## 常见问题

### Q: 推送后博客没有更新？
- 检查 GitHub Actions 是否运行成功（仓库 → Actions 标签页）
- 确认文章的 `draft: false`
- 等待 1-2 分钟 CDN 缓存刷新

### Q: 图片不显示？
- 图片放在 `static/images/` 目录
- 在 Markdown 中引用：`![alt](/images/xxx.png)`
- 确保图片文件名没有中文和空格

### Q: 想修改博客样式？
- PaperMod 支持丰富的自定义，参考 [PaperMod 文档](https://adityatelange.github.io/hugo-PaperMod/)
- 可以通过 `hugo.yaml` 的 `params` 配置大部分选项
- 高级定制可以在 `layouts/` 目录覆盖主题模板

### Q: 如何添加评论系统？
- PaperMod 支持 Giscus、Disqus、Utterances 等
- 推荐使用 [Giscus](https://giscus.app/)（基于 GitHub Discussions，免费）
