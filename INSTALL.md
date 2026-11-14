# prompt-translate 安装指南（供 AI Agent 执行）

用户把「帮我安装 prompt-translate：https://raw.githubusercontent.com/am5188/prompt-translate/main/INSTALL.md」这句话发给任意支持 skills 的 AI 客户端（Claude Code / Codex / Cursor / Gemini CLI / Trae / Hermes 等）后，本文件会作为安装依据。Agent 按以下步骤在终端完成安装。

## 前提检查

- 检查是否已安装至少一个支持 skills 的 AI 客户端（如 `which claude`、`which codex`、`which gemini`）。
- 若一个都没有，先执行：`npm i -g @anthropic-ai/claude-code`（或 `npm i -g @openai/codex`）。
- 检查 Node.js：`node --version`。有 Node.js 22.20+ 走步骤 1 方式一；没有走方式二。

## 步骤 1：安装

**方式一（推荐，有 Node.js）**

```shell
npx -y skills add am5188/prompt-translate -g
```

命令会自动检测本机客户端并安装/链接到对应目录，无需其他操作。

**方式二（零依赖，无 Node.js）**

```shell
for d in ~/.claude/skills ~/.codex/skills ~/.agents/skills ~/.gemini/skills ~/.cursor/skills; do mkdir -p "$d/prompt-translate"; curl -fsSL -o "$d/prompt-translate/SKILL.md" https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md; done
```

## 步骤 2：验证

确认 SKILL.md 已落到至少一个目标目录：

```shell
ls ~/.claude/skills/prompt-translate/SKILL.md ~/.codex/skills/prompt-translate/SKILL.md ~/.agents/skills/prompt-translate/SKILL.md ~/.gemini/skills/prompt-translate/SKILL.md ~/.cursor/skills/prompt-translate/SKILL.md 2>/dev/null
```

若方式一安装到了项目的 `.agents/skills/prompt-translate/SKILL.md`，同样视为成功。

## 步骤 3：完成

安装完成，无需重启即可使用（部分客户端需重开会话）。用户之后直接说：

- "帮我把这个需求翻译成 prompt：<需求>"
- "整理成 prompt：<需求>，给 Claude Code 用"

更新方式：`npx skills update`，或重跑步骤 1 的安装命令。
