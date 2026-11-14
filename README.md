# prompt-translate

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/am5188/prompt-translate)](https://github.com/am5188/prompt-translate/stargazers)

把模糊、口语化的中文需求，翻译成可复制粘贴给任何 AI 客户端执行的**结构化 Prompt**。

很多人跟 AI 客户端（Claude Code、Codex、Cursor……）沟通时说不清自己的需求——目标含糊、约束漏讲、验收标准没有，结果 AI 做出来的东西跑偏，来回返工。本 skill 解决的就是这个：你说人话，它给你一份能直接用的 Prompt。

## 核心行为

- **只翻译不执行**：产出 prompt 文本，不代做任务
- **中文进中文出**；最多一轮澄清（1-3 问），问不到就写"暂定假设"——**绝不编造**
- **清晰需求原样直通**：已经写好的 prompt 不会被乱改
- **一份文件通吃** Claude Code / Codex / Cursor / Gemini CLI / Hermes 等主流客户端

## 效果预览

**输入**（人话）：

> 我想做个东西，就是每天自动检查网站还活没活着，挂了给我发消息提醒我

**输出**（复制即用）：

```text
# 网站存活监控与告警通知工具

## 任务目标
实现一个定时任务：每天自动检查一组网站的存活状态，发现网站无法访问时通过消息推送提醒我。

## 约束条件
- 只做存活检查，不做内容篡改检测、性能监控等额外功能
- 正常运行时不打扰；异常时通知包含网站地址和失败原因

## 输出格式
可运行的代码 + 运行说明（依赖安装、网站列表配置、定时设置）

## 验收标准
- 手动关停一个测试网站后，下一次检查能触发通知
- 全部网站正常时静默完成，有日志可查

## 暂定假设
- 通知渠道：Telegram Bot　部署环境：Linux + Python
```

关键信息缺失时会先反问 1-3 个问题（只问影响方向的那种），或者写进"暂定假设"——**绝不编造**。已经写得很清晰的 prompt 原样返回，不会乱改。

## 安装

**方式一：让 AI 帮你装（推荐）**

把下面这句话直接发给你的 AI 客户端（Claude Code / Codex / Cursor / Trae……），它会自动完成安装：

```
帮我安装 prompt-translate：https://raw.githubusercontent.com/am5188/prompt-translate/main/INSTALL.md
```

**方式二：手动一条命令**

```bash
npx -y skills add am5188/prompt-translate -g
```

需要 Node.js 22.20+。升级：`npx skills update`。

<details>
<summary>其他安装方式（没有 Node.js / 手动）</summary>

### 零依赖一行命令（不需要 Node.js）

```bash
for d in ~/.claude/skills ~/.codex/skills ~/.agents/skills ~/.gemini/skills ~/.cursor/skills; do mkdir -p "$d/prompt-translate"; curl -fsSL -o "$d/prompt-translate/SKILL.md" https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md; done
```

### 按客户端逐条命令

**Claude Code**

```bash
mkdir -p ~/.claude/skills/prompt-translate && curl -fsSL -o ~/.claude/skills/prompt-translate/SKILL.md https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md
```

**Codex CLI**

```bash
mkdir -p ~/.codex/skills/prompt-translate && curl -fsSL -o ~/.codex/skills/prompt-translate/SKILL.md https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md
```

**Cursor**

```bash
mkdir -p ~/.cursor/skills/prompt-translate && curl -fsSL -o ~/.cursor/skills/prompt-translate/SKILL.md https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md
```

**Gemini CLI**

```bash
mkdir -p ~/.gemini/skills/prompt-translate && curl -fsSL -o ~/.gemini/skills/prompt-translate/SKILL.md https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md
```

**Hermes**

```bash
mkdir -p ~/.hermes/skills/productivity/prompt-translate && curl -fsSL -o ~/.hermes/skills/productivity/prompt-translate/SKILL.md https://raw.githubusercontent.com/am5188/prompt-translate/main/skills/prompt-translate/SKILL.md
```

升级：重跑同一命令。Windows 同样适用（PowerShell 自带 curl.exe）。

</details>

## 使用

在任意客户端里说：

- "帮我把这个需求翻译成 prompt：<需求>"
- "整理成 prompt：<需求>，给 Claude Code 用"
- "我想做个小工具，但不知道怎么描述，帮我写成 prompt"

不知道怎么开口？直接说"试试看"或"怎么用"，会先带你走一遍。

## 客户端兼容性

同一份 `SKILL.md` 遵循 [Agent Skills 开放标准](https://agentskills.io)，适用于所有主流客户端：

| 客户端 | 安装目录 | 调用方式 |
|---|---|---|
| Claude Code | `~/.claude/skills/prompt-translate/` | `/prompt-translate` 或自动触发 |
| Codex CLI | `~/.codex/skills/`（旧版）或 `~/.agents/skills/`（新版） | `$prompt-translate` 或自动触发 |
| Gemini CLI | `~/.gemini/skills/` | 自动触发 |
| Cursor | `~/.cursor/skills/`（同时兼容读取 `.claude/skills`、`.codex/skills`） | `/prompt-translate` 或自动触发 |
| Hermes | `~/.hermes/skills/productivity/prompt-translate/` | 说"翻译成 prompt"自动触发 |
| ChatGPT 桌面版 | 与 Codex skills 目录共用 | `@prompt-translate` |
| Trae / OpenClaw 等 | 同名 `SKILL.md`（`name`/`description`）格式 | 自动触发 |

两个前提：

1. 需要安装至少一个支持 skills 的客户端，没有就装：`npm i -g @anthropic-ai/claude-code` 或 `npm i -g @openai/codex`
2. 客户端用的模型需要懂中文（主流模型均可）

## 设计与调研

本 skill 的设计基于四路调研（GitHub 现成方案、12 篇 arXiv 论文、Anthropic/OpenAI/Google/Brex 官方指南、HuggingFace 专用模型评估），完整证据与来源见 [research.md](research.md)。核心结论：

- 模糊→精确的改写是提升 AI 执行质量最可靠的手段（实证平均 +15%~31%）
- 无"神奇咒语"：人设、情绪勒索、"一步步思考"默认不加，约束控制在 5-7 条
- 验收标准必须可验证，交付前逐条自检
- 用 harness 自带模型即可，专用小模型（HF 上全是玩具级）不值得引入

MIT License。
