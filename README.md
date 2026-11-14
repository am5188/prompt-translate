# prompt-translate

把模糊、口语化、不完整的自然语言需求"翻译"成可复制粘贴给任何 AI 客户端执行的结构化 Prompt。

单文件 skill，零依赖，遵循 [Agent Skills 开放标准](https://agentskills.io)（`SKILL.md` + `name`/`description` frontmatter）。翻译工作由 harness 客户端自己的模型完成，不调独立 API。

## 特性

- **只翻译不执行**：产出 Prompt 文本，不代做任务
- 中文进中文出（输入其他语言则跟随）
- 最多 1 轮澄清、每轮 1-3 个问题（只问影响方向的信息，熵达标即止）
- 按任务类型补全要点（编程/排查/写作/分析/数据处理）
- 输出单个代码块，复制即用；拿不准的信息标注"暂定假设"，不编造
- 可指明目标客户端，生成符合其习惯的执行要求

## 跨客户端支持

同一份 `SKILL.md` 适用于所有遵循 Agent Skills 标准的主流客户端：

| 客户端 | 安装目录 | 调用方式 |
|---|---|---|
| Hermes | `~/.hermes/skills/productivity/prompt-translate/` | 说"把需求翻译成 prompt"自动触发 |
| Claude Code | `~/.claude/skills/prompt-translate/` | `/prompt-translate` 或自动触发 |
| Codex CLI | `~/.codex/skills/`（旧版）或 `~/.agents/skills/`（新版） | `$prompt-translate` 或自动触发 |
| Gemini CLI | `~/.gemini/skills/`（`.agents/skills` 为别名） | 自动触发 |
| Cursor | `~/.cursor/skills/` 或 `~/.agents/skills/`；**同时兼容读取 `~/.claude/skills/` 和 `~/.codex/skills/`** | `/prompt-translate` 或自动触发 |
| ChatGPT 桌面版 | 与 Codex skills 目录共用 | `@prompt-translate` |
| Trae / OpenClaw 等 | 同名 `SKILL.md`（`name`/`description`）格式 | 自动触发 |

格式兼容要点（已按官方文档验证）：`name` 为小写 kebab-case 且与目录名一致（Cursor 硬性要求）；`description` 单行、含"做什么+何时用"（Gemini CLI 要求 frontmatter 是文件第一段且 description 单行）；frontmatter 仅含通用字段，无平台专属字段。

### 安装

```bash
# 本机一键安装到所有客户端目录（幂等）
./install.sh

# 查看各目录安装状态
./install.sh --list

# 或手动复制到指定客户端
mkdir -p ~/.claude/skills/prompt-translate
cp SKILL.md ~/.claude/skills/prompt-translate/
```

## 用法

在任意客户端里说：

- "帮我把这个需求翻译成 prompt：<需求>"
- "整理成 prompt：<需求>，给 Claude Code 用"
- "我想做个小工具，但不知道怎么描述，帮我写成 prompt"

## 分享给别人

对方只需要两样东西：**一个支持 skills 的客户端 + 本 skill 的 `SKILL.md`（一个文件）**。零依赖、零 API——翻译用对方客户端自己的模型跑。

三种方式（按维护成本从低到高）：

**A. 发文件包（一次性分享）**
把 `prompt-translate-v*.zip` 发给对方，解压后：

- Linux/macOS：终端执行 `./install.sh`
- Windows：双击 `install.bat`
- 或手动复制 `SKILL.md` 到目标目录（见上方兼容矩阵）

**B. GitHub 仓库（推荐，可更新）**
把本仓库推到 GitHub 后，对方一条命令安装，之后每次更新重跑同一命令即升级：

```bash
mkdir -p ~/.claude/skills/prompt-translate && curl -sSL -o ~/.claude/skills/prompt-translate/SKILL.md https://raw.githubusercontent.com/<你的账号>/prompt-translate/main/SKILL.md
```

（给 Claude Code 用上面的路径；其他客户端把目标目录换成兼容矩阵里的对应目录即可）

**C. 客户端市场（给大团队才值得）**
Cursor 团队市场 / Claude 插件市场可分发，但需要插件打包与市场发布，日常分享用 A/B 即可。

对方还没有客户端时：装 Claude Code（`npm i -g @anthropic-ai/claude-code`）或 Codex CLI（`npm i -g @openai/codex`），两者都免费安装、原生支持 skills。

注意：skill 面向中文用户（中文进中文出），对方客户端的模型需懂中文（主流模型均可）。

## 方法论来源

调研报告（含 GitHub/arXiv/文章/HuggingFace 四路完整证据与来源链接）：见 [research.md](research.md)。

借鉴了以下开源技能（未逐字复制，仅吸收方法）：

- `Jupiter363/universal-prompt-optimizer-skill`（MIT）：追问澄清 + 熵止步 + 标准化结构
- `ZHN123456cn/intent-to-prompt`：只生成不执行、单代码块输出契约
- `JiuNian3219/intent-to-prompt-skill`：意图挖掘维度与澄清分级
