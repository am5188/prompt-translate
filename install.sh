#!/usr/bin/env bash
# prompt-translate 跨 harness 安装脚本
# 把本目录的 SKILL.md 复制到本机所有主流 AI 客户端的 skills 目录（幂等，可重复执行）。
# 用法: ./install.sh            # 安装到所有已支持目录
#       ./install.sh --list     # 只列出目标目录，不执行
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/skills/prompt-translate/SKILL.md"

# 各客户端 skills 目录（不存在的目录会自动创建；客户端未安装时复制进去也无害）
TARGETS=(
  "$HOME/.claude/skills/prompt-translate"              # Claude Code
  "$HOME/.codex/skills/prompt-translate"               # Codex CLI（旧版目录）
  "$HOME/.agents/skills/prompt-translate"              # Codex CLI（新版）/ Gemini CLI 别名 / Cursor
  "$HOME/.gemini/skills/prompt-translate"              # Gemini CLI
  "$HOME/.cursor/skills/prompt-translate"              # Cursor（本机；Cloud Agents 同步需在 Cursor 设置中开启）
  "$HOME/.hermes/skills/productivity/prompt-translate" # Hermes
)

if [[ "${1:-}" == "--list" ]]; then
  for t in "${TARGETS[@]}"; do
    if [[ -f "$t/SKILL.md" ]]; then
      echo "已安装  $t"
    else
      echo "未安装  $t"
    fi
  done
  exit 0
fi

[[ -f "$SRC" ]] || { echo "错误: 找不到 $SRC" >&2; exit 1; }

count=0
for t in "${TARGETS[@]}"; do
  mkdir -p "$t"
  cp "$SRC" "$t/SKILL.md"
  echo "→ $t/SKILL.md"
  count=$((count + 1))
done

echo "完成：已安装到 $count 个目录。"
echo "提示：Cursor 会同时读取 ~/.claude/skills 与 ~/.codex/skills，重复安装无副作用。"
