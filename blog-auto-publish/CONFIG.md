# ⚙️ 配置参考 (Configuration Reference)

## Hugo 配置详解 (hugo.yaml)

### 基础配置

```yaml
# 站点 URL（重要！部署前必须正确设置）
baseURL: https://<你的用户名>.github.io/

# 语言设置
languageCode: zh-cn
defaultContentLanguage: zh

# 站点标题
title: 无名的博客

# 使用的主题
theme: PaperMod

# 启用功能
enableEmoji: true          # 支持 emoji
enableRobotsTXT: true      # 生成 robots.txt
buildDrafts: false         # 不构建草稿
buildFuture: false         # 不构建未来日期的文章

# URL 配置
uglyURLs: false            # 使用干净的 URL (/posts/xxx/ 而不是 /posts/xxx.html)
canonifyURLs: true         # 规范化 URL
```

### PaperMod 主题参数

```yaml
params:
  # 作者信息
  author: 无名
  description: "个人博客 - 记录技术与生活"
  keywords: [Blog, 技术, 编程, 生活]

  # 主题模式
  defaultTheme: auto       # auto | light | dark
  # auto: 跟随系统偏好
  # light: 始终亮色
  # dark: 始终暗色

  # 显示选项
  ShowReadingTime: true    # 显示阅读时间
  ShowWordCount: true      # 显示字数
  ShowBreadCrumbs: true    # 显示面包屑导航
  ShowPostNavLinks: true   # 显示上一篇/下一篇
  ShowCodeCopyButtons: true # 代码块复制按钮
  ShowToc: true            # 显示目录
  TocOpen: false           # 目录默认展开
  ShowShareButtons: false  # 显示分享按钮
  ShareButtons: ["linkedin", "twitter", "reddit", "facebook"]

  # 主页信息模式
  homeInfoParams:
    Title: "你好 👋"
    Content: >
      欢迎来到我的博客。
      这里记录我的技术探索和生活感悟。
    # 也可以用按钮
    # Type: "profile"  # profile 模式显示头像和社交链接

  # 社交图标
  socialIcons:
    - name: github
      url: "https://github.com/<你的用户名>"
    - name: twitter
      url: "https://twitter.com/<你的用户名>"
    - name: email
      url: "mailto:<你的邮箱>"
    - name: rss
      url: "/index.xml"
    # 更多图标：linkedin, stackoverflow, discord, youtube, etc.

  # 封面图片
  cover:
    hidden: false           # 全局隐藏封面
    hiddenInList: false     # 列表页隐藏封面
    hiddenInSingle: false   # 文章页隐藏封面

  # 编辑文章链接（可选）
  editPost:
    URL: "https://github.com/<用户名>/<仓库名>/tree/main/content/posts"
    Text: "在 GitHub 上编辑此文章"
    appendFilePath: true

  # 搜索配置
  fuseOpts:
    isCaseSensitive: false
    shouldSort: true
    location: 0
    distance: 1000
    threshold: 0.4
    minMatchCharLength: 0
    keys: ["title", "permalink", "summary", "content"]

  # 标签页显示文章数量
  archivePaginate: 50

  # 页脚信息
  label:
    text: "无名"
    icon: "🪶"
    iconHeight: 35
```

### 导航菜单

```yaml
menu:
  main:
    - identifier: search
      name: 搜索
      url: /search/
      weight: 10
    - identifier: archives
      name: 归档
      url: /archives/
      weight: 20
    - identifier: tags
      name: 标签
      url: /tags/
      weight: 30
    - identifier: categories
      name: 分类
      url: /categories/
      weight: 40
    - identifier: about
      name: 关于
      url: /about/
      weight: 50
```

### 输出格式

```yaml
outputs:
  home:
    - HTML
    - RSS
    - JSON    # 搜索功能需要 JSON 输出

  page:
    - HTML

  section:
    - HTML
    - RSS
```

### Markdown 渲染配置

```yaml
markup:
  # 代码高亮
  highlight:
    noClasses: false        # 使用 class 而非内联样式
    codeFences: true        # 支持围栏代码块
    guessSyntax: true       # 自动猜测语言
    lineNos: true           # 显示行号
    lineNumbersInTable: true # 行号在表格中
    style: monokai          # 高亮主题

  # Goldmark 渲染器
  goldmark:
    renderer:
      unsafe: true          # 允许 HTML 标签（用于嵌入视频等）
    parser:
      attribute:
        block: true         # 支持块级属性
        title: true         # 支持标题属性

  # 目录
  tableOfContents:
    startLevel: 2           # 从 h2 开始
    endLevel: 4             # 到 h4 结束
    ordered: false          # 无序列表
```

### 隐私配置

```yaml
privacy:
  vimeo:
    disabled: false
    simple: true
  twitter:
    disabled: false
    enableDNT: true
    simple: true
  instagram:
    disabled: false
    simple: true
  youtube:
    disabled: false
    privacyEnhanced: true
```

### SEO 配置

```yaml
# Sitemap
sitemap:
  changefreq: monthly
  filename: sitemap.xml
  priority: 0.5

# robots.txt（如果 enableRobotsTXT: true）
# 自动生成，无需额外配置
```

---

## GitHub Actions 配置详解

### 工作流文件结构

```yaml
# .github/workflows/deploy.yml

# 工作流名称
name: Deploy Hugo to GitHub Pages

# 触发条件
on:
  push:
    branches:
      - main              # main 分支推送时触发
  workflow_dispatch:       # 允许手动触发

# 权限设置
permissions:
  contents: read           # 读取仓库内容
  pages: write             # 写入 Pages
  id-token: write          # Pages 部署需要

# 并发控制
concurrency:
  group: "pages"
  cancel-in-progress: false # 不取消正在运行的部署

# 默认 Shell
defaults:
  run:
    shell: bash

# 任务定义
jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.140.2  # Hugo 版本，按需更新
    steps:
      # Step 1: 安装 Hugo
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb \
            https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
          sudo dpkg -i ${{ runner.temp }}/hugo.deb

      # Step 2: 检出代码
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive  # 拉取主题 submodule
          fetch-depth: 0         # 完整历史（支持 .Lastmod）

      # Step 3: 配置 Pages
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5

      # Step 4: 构建
      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: Asia/Shanghai       # 时区
        run: |
          hugo \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"

      # Step 5: 上传构建产物
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
      # Step 6: 部署
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 更新 Hugo 版本

查看最新版本：https://github.com/gohugoio/hugo/releases

修改 `HUGO_VERSION` 环境变量即可。

---

## PaperMod 主题进阶定制

### 自定义 CSS

创建 `assets/css/extended/custom.css`：

```css
/* 自定义字体 */
body {
  font-family: "LXGW WenKai", sans-serif;
}

/* 自定义代码块样式 */
.post-content pre {
  border-radius: 8px;
}

/* 自定义链接颜色 */
.post-content a {
  color: #3b82f6;
}
```

在 `hugo.yaml` 中引入：

```yaml
params:
  assets:
    disableFingerprinting: true
```

### 自定义布局覆盖

在 `layouts/` 目录下创建与主题同路径的文件即可覆盖：

```
layouts/
├── partials/
│   ├── footer.html        # 自定义页脚
│   ├── head.html          # 自定义 head（添加字体、分析代码等）
│   └── header.html        # 自定义头部
├── index.html             # 自定义首页
└── _default/
    └── baseof.html        # 基础模板
```

### 添加 Google Analytics

在 `hugo.yaml` 中：

```yaml
services:
  googleAnalytics:
    ID: G-XXXXXXXXXX
```

### 添加评论系统（Giscus）

在 `layouts/partials/comments.html` 中：

```html
<script src="https://giscus.app/client.js"
  data-repo="<你的用户名>/<你的仓库>"
  data-repo-id="<仓库ID>"
  data-category="Announcements"
  data-category-id="<分类ID>"
  data-mapping="pathname"
  data-strict="0"
  data-reactions-enabled="1"
  data-emit-metadata="0"
  data-input-position="bottom"
  data-theme="preferred_color_scheme"
  data-lang="zh-CN"
  crossorigin="anonymous"
  async>
</script>
```

在 `hugo.yaml` 中启用：

```yaml
params:
  comments: true
```

---

## 常用 Hugo 命令速查

| 命令 | 说明 |
|------|------|
| `hugo` | 构建站点到 `public/` |
| `hugo server` | 启动开发服务器 (localhost:1313) |
| `hugo server -D` | 开发服务器，包含草稿 |
| `hugo server -w` | 监听文件变化自动重载 |
| `hugo new posts/xxx.md` | 创建新文章 |
| `hugo list drafts` | 列出所有草稿 |
| `hugo list all` | 列出所有内容 |
| `hugo --minify` | 构建并压缩输出 |
| `hugo config` | 查看当前配置 |

---

## PaperMod 功能模式

### 1. 博客模式（默认）

标准博客列表 + 文章详情。

### 2. 主页信息模式

在 `hugo.yaml` 中配置 `homeInfoParams`，首页显示自定义介绍信息。

### 3. Profile 模式

```yaml
params:
  homeInfoParams:
    Type: "profile"
```

首页显示头像和社交链接，适合个人主页风格。

### 4. 归档模式

访问 `/archives/` 自动生成时间线归档页面。

---

## 参考链接

- [Hugo 官方文档](https://gohugo.io/documentation/)
- [PaperMod 主题文档](https://adityatelange.github.io/hugo-PaperMod/)
- [PaperMod GitHub](https://github.com/adityatelange/hugo-PaperMod)
- [GitHub Pages 文档](https://docs.github.com/zh/pages)
- [GitHub Actions 文档](https://docs.github.com/zh/actions)
- [Markdown 指南](https://www.markdownguide.org/)
