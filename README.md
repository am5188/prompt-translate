# prompt-translate

把模糊、口语化、不完整的自然语言需求"翻译"成可复制粘贴给任何 AI 客户端（Hermes、Claude Code、Codex、Cursor）执行的结构化 Prompt。

Hermes skill，单文件零依赖。翻译工作由 harness 客户端自己的模型完成，不调独立 API。

## 特性

- **只翻译不执行**：产出 Prompt 文本，不代做任务
- 中文进中文出（输入其他语言则跟随）
- 最多 1 轮澄清、每轮 1-3 个问题（只问影响方向的信息，熵达标即止）
- 按任务类型补全要点（编程/排查/写作/分析/数据处理）
- 输出单个代码块，复制即用；拿不准的信息标注"暂定假设"，不编造

## 安装

- **Hermes**（本机已装）：`~/.hermes/skills/productivity/prompt-translate/`
- **Claude Code**：把 `SKILL.md` 放进 `~/.claude/skills/prompt-translate/`
- **Codex**：把 `SKILL.md` 放进 `~/.codex/skills/prompt-translate/`

## 用法

在 harness 客户端里说：

- "帮我把这个需求翻译成 prompt：<需求>"
- "整理成 prompt：<需求>"
- "我想做个小工具，但不知道怎么描述，帮我写成 prompt"

## 方法论来源

借鉴了以下开源技能（未逐字复制，仅吸收方法）：

- `Jupiter363/universal-prompt-optimizer-skill`（MIT）：追问澄清 + 熵止步 + 标准化结构
- `ZHN123456cn/intent-to-prompt`：只生成不执行、单代码块输出契约
- `JiuNian3219/intent-to-prompt-skill`：意图挖掘维度与澄清分级
