#!/usr/bin/env bash
# ============================================================
# setup.sh · 噜噜终端一键安装
# 用法: bash <(curl -sL https://raw.githubusercontent.com/YOUR_USER/lulu-terminal/main/setup.sh)
# ============================================================

set -euo pipefail

# ---- 颜色 ----
R='\033[0m'; O='\033[38;2;245;155;50m'; P='\033[38;2;246;166;200m'
Y='\033[38;2;247;214;58m'; G='\033[38;2;138;174;90m'; RD='\033[38;2;230;106;122m'
B='\033[1m'; D='\033[2m'

info()  { printf "${O}🍊 %s${R}\n" "$*"; }
ok()    { printf "${G}✅ %s${R}\n" "$*"; }
warn()  { printf "${Y}⚠️  %s${R}\n" "$*"; }
err()   { printf "${RD}❌ %s${R}\n" "$*" >&2; }
hint()  { printf "${D}   %s${R}\n" "$*"; }
title() { printf "\n${B}${P}🐾 %s${R}\n\n" "$*"; }

ask_yes_no() {
    local prompt="$1" default="${2:-y}" yn
    [[ "$default" == "y" ]] && yn="[Y/n]" || yn="[y/N]"
    printf "${P}%s %s ${R}" "$prompt" "$yn"
    read -r answer
    answer="${answer:-$default}"
    [[ "$answer" =~ ^[Yy]$ ]]
}

# ---- 常量 ----
INSTALL_DIR="$HOME/.lulu-terminal"
BIN_DIR="$HOME/.local/bin"
LULU_BIN="$BIN_DIR/lulu"
ZSHRC="$HOME/.zshrc"
MARKER_START="# >>> lulu-terminal >>>"
MARKER_END="# <<< lulu-terminal <<<"

# ---- 系统检查 ----
check_system() {
    if [[ "$(uname)" != "Darwin" ]]; then
        err "此工具仅支持 macOS。"
        exit 1
    fi
    info "macOS 系统 ✓"

    if ! command -v brew &>/dev/null; then
        warn "未找到 Homebrew。"
        if ask_yes_no "是否安装 Homebrew？（需要管理员密码）"; then
            info "正在安装 Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Apple Silicon 需要加 PATH
            if [[ -f /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        else
            err "Homebrew 是必需的，请先手动安装: https://brew.sh"
            exit 1
        fi
    fi
    ok "Homebrew ✓"
}

install_deps() {
    info "检查依赖..."

    local deps_ok=true

    if command -v ghostty &>/dev/null; then
        ok "Ghostty 已安装"
    else
        warn "Ghostty 未安装"
        if ask_yes_no "用 Homebrew 安装 Ghostty？"; then
            brew install --cask ghostty && ok "Ghostty ✓" || { err "Ghostty 安装失败"; deps_ok=false; }
        else
            warn "跳过 Ghostty"; deps_ok=false
        fi
    fi

    if command -v starship &>/dev/null; then
        ok "Starship 已安装"
    else
        warn "Starship 未安装"
        if ask_yes_no "用 Homebrew 安装 Starship？"; then
            brew install starship && ok "Starship ✓" || { err "Starship 安装失败"; deps_ok=false; }
        else
            warn "跳过 Starship"; deps_ok=false
        fi
    fi

    if command -v fastfetch &>/dev/null; then
        ok "Fastfetch 已安装"
    else
        warn "Fastfetch 未安装"
        if ask_yes_no "用 Homebrew 安装 Fastfetch？"; then
            brew install fastfetch && ok "Fastfetch ✓" || { err "Fastfetch 安装失败"; deps_ok=false; }
        else
            warn "跳过 Fastfetch"; deps_ok=false
        fi
    fi

    # 推荐字体
    echo ""
    hint "推荐安装 Maple Mono NF CN 字体（支持中文 + Nerd Font 图标）"
    if ask_yes_no "是否安装 Maple Mono NF CN 字体？" "n"; then
        brew install --cask font-maple-mono-nf-cn && ok "字体已安装" || warn "字体安装失败，可稍后手动安装"
    fi
}

# ---- 下载项目 ----
download_project() {
    if [[ -d "$INSTALL_DIR/.git" ]]; then
        info "检测到已安装，更新中..."
        cd "$INSTALL_DIR" && git pull --quiet && ok "已更新" && return
    fi

    # 如果是通过 pipe 运行的（没有 git clone 过），从 GitHub 下载
    local repo_url="${LULU_REPO_URL:-https://github.com/Jackey0903/lulu-terminal.git}"
    info "下载噜噜终端到 $INSTALL_DIR ..."
    git clone --quiet "$repo_url" "$INSTALL_DIR" 2>/dev/null && ok "下载完成" && return

    # 如果 GitHub 不可用，检查是否在项目目录内运行
    if [[ -f "./lulu" ]] && [[ -d "./themes" ]]; then
        info "从当前目录复制..."
        cp -r . "$INSTALL_DIR"
        ok "复制完成"
    else
        err "下载失败。请手动 clone 到 $INSTALL_DIR"
        exit 1
    fi
}

# ---- 配置 .zshrc ----
setup_zshrc() {
    # 移除旧块
    if [[ -f "$ZSHRC" ]] && grep -q "$MARKER_START" "$ZSHRC"; then
        sed -i.bak "/$MARKER_START/,/$MARKER_END/d" "$ZSHRC"
        rm -f "$ZSHRC.bak"
    fi

    # 写入新块（starship init + fastfetch + lulu PATH）
    cat >> "$ZSHRC" << 'ZSH_BLOCK'

# >>> lulu-terminal >>>
export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init zsh)"
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
# <<< lulu-terminal <<<
ZSH_BLOCK

    ok "已配置 ~/.zshrc"
}

# ---- 安装 lulu 命令 ----
install_lulu_command() {
    mkdir -p "$BIN_DIR"

    # 创建全局 lulu 命令，指向安装目录
    cat > "$LULU_BIN" << WRAPPER
#!/usr/bin/env bash
exec "$INSTALL_DIR/lulu" "\$@"
WRAPPER
    chmod +x "$LULU_BIN"

    ok "lulu 命令已安装到 $BIN_DIR"
    hint "之后在任意目录输入 lulu 即可使用"
}

# ---- 配置主题 ----
apply_default_theme() {
    echo ""
    printf "${B}选择默认主题：${R}\n"
    printf "  ${Y}1)${R} banana-day   🍌 白天模式（奶油黄，温暖明亮）\n"
    printf "  ${Y}2)${R} choco-night  🌙 夜间模式（深巧克力，安静沉稳）\n"
    printf "\n${P}请输入选项 [1]: ${R}"
    read -r choice
    local theme
    case "${choice:-1}" in
        1) theme="banana-day" ;;
        2) theme="choco-night" ;;
        *) theme="banana-day" ;;
    esac

    "$INSTALL_DIR/lulu" switch "$theme" --silent
    ok "已应用 $theme 主题"
}

# ---- 主流程 ----
main() {
    title "安装噜噜终端 · lulu-terminal"
    printf "${D}水豚噜噜和小狗布丁陪你写代码 🍊🐾${R}\n\n"

    check_system
    install_deps
    download_project
    install_lulu_command
    setup_zshrc
    apply_default_theme

    echo ""
    printf "${B}${G}════════════════════════════════════════════════${R}\n"
    printf "${B}${G}  🎉 安装完成！${R}\n"
    printf "${B}${G}════════════════════════════════════════════════${R}\n"
    echo ""
    hint "请关闭并重新打开终端，即可看到效果。"
    echo ""
    hint "之后可以随时使用以下命令："
    printf "  ${Y}lulu switch banana-day${R}   切换白天模式\n"
    printf "  ${Y}lulu switch choco-night${R}  切换夜间模式\n"
    printf "  ${Y}lulu status${R}             查看状态\n"
    printf "  ${Y}lulu uninstall${R}          卸载\n"
    echo ""
    printf "${P}🍊 慢慢来，布丁在香蕉窝里等你。${R}\n\n"
}

main
