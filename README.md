# 🍊 噜噜终端 · lulu-terminal

> 一个可爱的 macOS 终端治愈系主题工具。
> 水豚噜噜和小狗布丁陪你写代码。

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Shell](https://img.shields.io/badge/shell-zsh-green)

---

## 📖 简介

**噜噜终端** 不是一个新的终端 App，而是一套通过配置 [Ghostty](https://ghostty.org/)、[Starship](https://starship.rs/)、[Fastfetch](https://github.com/fastfetch-cli/fastfetch) 和 zsh 打造的治愈系终端主题包。

灵感来自两个小伙伴：

- **噜噜** —— 佛系、圆润、情绪稳定的水豚。元素：橘子、温泉、慢慢来。
- **布丁** —— 深巧克力棕色毛茸茸小型犬，常戴粉色胸背，喜欢躺在黄色香蕉窝里。

### 🎨 两套主题

| 主题 | 风格 | 背景 | 提示符 |
|------|------|------|--------|
| `banana-day` | 明亮温暖的白天模式 | 奶油黄 `#FFF4C7` | `🍌 布丁的小窝 ❯` |
| `choco-night` | 安静沉稳的夜间模式 | 深巧克力 `#1E1410` | `🌙 布丁趴好了 ❯` |

---

## 🚀 安装

### 前置条件

- macOS（支持 zsh）
- [Homebrew](https://brew.sh/)（如果没有会自动提示安装）

### 一行命令安装

打开终端，粘贴这一行：

```bash
bash <(curl -sL https://raw.githubusercontent.com/jackluo2012/lulu-terminal/main/setup.sh)
```

安装过程会：
1. 检查并安装依赖（Ghostty、Starship、Fastfetch）
2. 选择默认主题（白天/夜间）
3. 自动配置 `~/.zshrc`
4. 安装 `lulu` 全局命令

安装完成后，**重新打开终端**即可看到效果。

---

## 🎮 日常使用

安装完成后，`lulu` 命令在任意目录可用：

```bash
# 切换主题
lulu switch banana-day    # 🍌 白天模式：奶油黄，温暖明亮
lulu switch choco-night   # 🌙 夜间模式：深巧克力，安静沉稳

# 查看状态
lulu status

# 更新到最新版
lulu update

# 卸载
lulu uninstall
```

---

## 🎨 自定义颜色

所有颜色定义在以下文件中，你可以按喜好修改：

### Ghostty 终端颜色

编辑 `~/.config/ghostty/config`（由 `lulu switch` 自动复制）：

| 色值 | 名称 | 用途 |
|------|------|------|
| `#FFF4C7` | Soft Cream | 白天背景 |
| `#1E1410` | Deep Choco | 夜间背景 |
| `#3A2A22` | Choco Brown | 文字 |
| `#F6A6C8` | Pudding Pink | 光标、目录 |
| `#F7D63A` | Banana Yellow | 高亮 |
| `#F59B32` | Orange Lulu | 夜间提示符 |
| `#8AAE5A` | Matcha Green | 成功提示 |
| `#E66A7A` | Berry Red | 错误提示 |

### Starship 提示符

编辑 `~/.config/starship.toml`，修改 `[palettes.lulu]` 中的颜色值。

### 推荐字体

主题默认使用 **Maple Mono NF CN**（支持中文和 Nerd Font 图标）：

```bash
brew install --cask font-maple-mono-nf-cn
```

---

## 📁 项目结构

```
lulu-terminal/
├── README.md                       # 本文件
├── setup.sh                        # 一键安装脚本（curl 用）
├── lulu                            # CLI 主程序
├── themes/
│   ├── ghostty-banana-day.conf     # Ghostty 白天主题
│   └── ghostty-choco-night.conf    # Ghostty 夜间主题
├── starship/
│   ├── banana-day.toml             # Starship 白天配置
│   └── choco-night.toml            # Starship 夜间配置
├── fastfetch/
│   ├── pudding-lulu-logo.txt       # ASCII 开屏图案
│   └── config.jsonc                # Fastfetch 配置
└── assets/
    ├── preview-banana-day.txt      # 白天主题预览
    └── preview-choco-night.txt     # 夜间主题预览
```

---

## 💡 小贴士

- 两个主题可以随时切换，配置文件互不干扰。
- 安装脚本使用标记块管理 `.zshrc`，不会影响你的其他 zsh 配置。
- 卸载时可以选择保留配置文件，方便下次重装。
- Starship 提示符会自动显示当前目录、Git 分支、编程语言版本等信息。

---

## 📜 版权说明

本项目为 **原创主题设计**，灵感来源于个人宠物（水豚噜噜和小狗布丁）的治愈意象。

- 所有 ASCII 艺术、配色方案、提示符设计均为原创。
- 本项目 **不包含** 任何第三方 IP 官方素材。
- 水豚（capybara）和巧克力色小型犬为自然动物形象，不属于任何特定 IP。
- 如需商用或二次分发，请保留原始版权声明。

---

## 📄 许可证

MIT License

---

<p align="center">
  🍊 慢慢来，布丁在香蕉窝里等你。<br>
  🐾 写代码也要开开心心的。
</p>
